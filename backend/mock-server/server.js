// Local mock server implementing the Proposed API Contract (PLAN.md section 16) on top of json-server, so Flutter can run against something real instead of waiting for the real backend [C1]; dev tooling only, not part of the app or a real production backend, and its tokens are fake. Run: cd backend/mock-server && npm install && npm start (serves http://localhost:3000; run Flutter with --dart-define=API_BASE_URL=http://localhost:3000).

const jsonServer = require('json-server');
const { randomUUID } = require('crypto');

const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();

server.use(middlewares);
server.use(jsonServer.bodyParser);

const PREFIX = '/api/v1';
const fakeToken = (userId) => `mock-token-${userId}-${Date.now()}`;

function findUserByEmail(email) {
  return router.db.get('users').find({ email }).value();
}

function publicUser(user) {
  if (!user) return null;
  const { password, ...rest } = user;
  return rest;
}

// ---------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------

server.post(`${PREFIX}/auth/register`, (req, res) => {
  const { username, email, password, avatarId } = req.body ?? {};
  if (!username || !email || !password) {
    return res.status(422).json({ message: 'username, email, and password are required' });
  }
  if (findUserByEmail(email)) {
    return res.status(409).json({ message: 'الإيميل ده مستخدم بالفعل يا جار' });
  }

  const newUser = {
    id: randomUUID(),
    username,
    email,
    password,
    displayName: username,
    avatarId: avatarId ?? null,
    bio: '',
  };
  router.db.get('users').push(newUser).write();

  return res.status(201).json({
    user: publicUser(newUser),
    accessToken: fakeToken(newUser.id),
    refreshToken: fakeToken(newUser.id),
  });
});

server.post(`${PREFIX}/auth/login`, (req, res) => {
  const { email, password } = req.body ?? {};
  const user = findUserByEmail(email);

  if (!user || user.password !== password) {
    return res.status(401).json({ message: 'بيانات الدخول غلط يا ساكن القاع' });
  }

  return res.status(200).json({
    user: publicUser(user),
    accessToken: fakeToken(user.id),
    refreshToken: fakeToken(user.id),
  });
});

server.post(`${PREFIX}/auth/refresh`, (req, res) => {
  // Mock only — returns a fake new access token without actually validating the refresh token.
  return res.status(200).json({ accessToken: fakeToken('refreshed') });
});

server.post(`${PREFIX}/auth/logout`, (_req, res) => res.status(204).send());

server.get(`${PREFIX}/auth/me`, (_req, res) => {
  const user = router.db.get('users').first().value();
  return res.status(200).json(publicUser(user));
});

// ---------------------------------------------------------------------
// Home
// ---------------------------------------------------------------------

server.get(`${PREFIX}/complaints/trending`, (req, res) => {
  const limit = Number(req.query.limit) || 5;
  const trending = router.db
    .get('complaints')
    .orderBy(['likes'], ['desc'])
    .take(limit)
    .value();
  return res.status(200).json(trending);
});

server.get(`${PREFIX}/users/me/recent-activity`, (req, res) => {
  const limit = Number(req.query.limit) || 5;
  const recent = router.db
    .get('complaints')
    .orderBy(['createdAt'], ['desc'])
    .take(limit)
    .value();
  return res.status(200).json(recent);
});

// ---------------------------------------------------------------------
// Comments & Reactions (nested paths — default json-server doesn't support nesting, so custom routes are needed)
// ---------------------------------------------------------------------

server.get(`${PREFIX}/complaints/:id/comments`, (req, res) => {
  const items = router.db.get('comments').filter({ complaintId: req.params.id }).value();
  return res.status(200).json({ items, page: 1, totalPages: 1 });
});

server.post(`${PREFIX}/complaints/:id/comments`, (req, res) => {
  const comment = {
    id: randomUUID(),
    complaintId: req.params.id,
    authorId: 'u1',
    authorName: req.body?.authorName ?? 'ساكن القاع',
    text: req.body?.text ?? '',
    createdAt: new Date().toISOString(),
  };
  router.db.get('comments').push(comment).write();
  return res.status(201).json(comment);
});

server.delete(`${PREFIX}/comments/:commentId`, (req, res) => {
  router.db.get('comments').remove({ id: req.params.commentId }).write();
  return res.status(204).send();
});

server.post(`${PREFIX}/complaints/:id/reactions`, (req, res) => {
  const complaint = router.db.get('complaints').find({ id: req.params.id });
  if (complaint.value()) complaint.update('likes', (n) => (n ?? 0) + 1).write();
  return res.status(200).json({ liked: true });
});

server.delete(`${PREFIX}/complaints/:id/reactions`, (req, res) => {
  const complaint = router.db.get('complaints').find({ id: req.params.id });
  if (complaint.value()) complaint.update('likes', (n) => Math.max(0, (n ?? 0) - 1)).write();
  return res.status(200).json({ liked: false });
});

// ---------------------------------------------------------------------
// Complaint status (scope pending Q2 in PLAN.md — open here for development only)
// ---------------------------------------------------------------------

server.patch(`${PREFIX}/complaints/:id/status`, (req, res) => {
  const complaint = router.db.get('complaints').find({ id: req.params.id });
  if (!complaint.value()) return res.status(404).json({ message: 'الشكوى دي مش موجودة' });
  complaint.assign({ status: req.body?.status }).write();
  return res.status(200).json(complaint.value());
});

// ---------------------------------------------------------------------
// Map — lightweight projection (id/lat/lng/categoryId/status only)
// ---------------------------------------------------------------------

server.get(`${PREFIX}/complaints/map`, (_req, res) => {
  const items = router.db
    .get('complaints')
    .map((c) => ({ id: c.id, lat: c.lat, lng: c.lng, categoryId: c.categoryId, status: c.status }))
    .value();
  return res.status(200).json(items);
});

// ---------------------------------------------------------------------
// Notifications
// ---------------------------------------------------------------------

server.post(`${PREFIX}/notifications/:id/read`, (req, res) => {
  const notification = router.db.get('notifications').find({ id: req.params.id });
  if (notification.value()) notification.assign({ isRead: true }).write();
  return res.status(200).json({ ok: true });
});

server.post(`${PREFIX}/notifications/read-all`, (_req, res) => {
  router.db.get('notifications').forEach((n) => (n.isRead = true)).write();
  return res.status(200).json({ ok: true });
});

server.post(`${PREFIX}/devices`, (_req, res) => res.status(201).json({ ok: true }));

// ---------------------------------------------------------------------
// Profile
// ---------------------------------------------------------------------

server.get(`${PREFIX}/users/me/stats`, (_req, res) => {
  const complaints = router.db.get('complaints').value();
  return res.status(200).json({
    submittedCount: complaints.length,
    resolvedCount: complaints.filter((c) => c.status === 'resolved').length,
    points: complaints.length * 10,
  });
});

server.patch(`${PREFIX}/users/me`, (req, res) => {
  const user = router.db.get('users').first();
  user.assign(req.body ?? {}).write();
  return res.status(200).json(publicUser(user.value()));
});

// ---------------------------------------------------------------------
// Media (fake upload — returns a placeholder URL instead of storing a real file)
// ---------------------------------------------------------------------

server.post(`${PREFIX}/media`, (_req, res) => {
  const mediaId = randomUUID();
  return res.status(201).json({
    mediaId,
    url: `https://placehold.co/600x400?text=${mediaId}`,
  });
});

// ---------------------------------------------------------------------
// Remaining standard resources (categories, complaints CRUD/list/detail) are covered automatically by the default json-server router, after rewriting /api/v1/x to /x.
// ---------------------------------------------------------------------

server.use(jsonServer.rewriter({ '/api/v1/*': '/$1' }));
server.use(router);

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`صوت القاع mock server شغّال على http://localhost:${PORT}${PREFIX}`);
});
