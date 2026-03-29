<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="theme-color" content="#0f1a2e">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<link rel="manifest" href="public/manifest.json">
<link rel="icon" href="public/icons/icon.svg" type="image/svg+xml">
<title>FinApp — Create Account</title>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  body {
    font-family: 'Inter', system-ui, sans-serif;
    background: #060b16;
    color: #e5ecff;
    min-height: 100dvh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.5rem;
  }
  .auth-wrap {
    width: 100%;
    max-width: 400px;
    background: #0f1a2e;
    border-radius: 18px;
    padding: 2.4rem 2rem;
    box-shadow: 0 16px 48px rgba(0,0,0,0.5);
    border: 1px solid rgba(120,150,210,0.12);
  }
  .auth-logo { font-size: 2.4rem; text-align: center; margin-bottom: 0.4rem; }
  .auth-title { font-size: 1.25rem; font-weight: 700; text-align: center; color: #e5ecff; margin-bottom: 0.25rem; }
  .auth-sub { font-size: 0.82rem; color: #7a94c4; text-align: center; margin-bottom: 2rem; }
  .form-group { margin-bottom: 1.1rem; }
  label { display: block; font-size: 0.78rem; color: #7a94c4; text-transform: uppercase; letter-spacing: .06em; margin-bottom: 0.45rem; }
  input[type=text], input[type=email], input[type=password] {
    width: 100%;
    background: #060b16;
    border: 1px solid rgba(120,150,210,0.2);
    border-radius: 10px;
    padding: 0.8rem 1rem;
    font-size: 0.95rem;
    color: #e5ecff;
    outline: none;
    transition: border-color .2s;
  }
  input:focus { border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.15); }
  .auth-error {
    background: rgba(244,63,94,0.12);
    border: 1px solid rgba(244,63,94,0.35);
    color: #f87171;
    font-size: 0.83rem;
    border-radius: 8px;
    padding: 0.65rem 0.9rem;
    margin-bottom: 1rem;
  }
  button[type=submit] {
    width: 100%;
    padding: 0.85rem;
    background: #3b82f6;
    color: #fff;
    border: none;
    border-radius: 10px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background .18s;
    margin-top: 0.5rem;
  }
  button[type=submit]:hover { background: #2563eb; }
  button[type=submit]:active { background: #1d4ed8; }
  .auth-footer { text-align: center; margin-top: 1.5rem; font-size: 0.83rem; color: #7a94c4; }
  .auth-footer a { color: #3b82f6; text-decoration: none; }
  .auth-footer a:hover { text-decoration: underline; }
  .hint { font-size: 0.75rem; color: #7a94c4; margin-top: 0.35rem; }
</style>
</head>
<body>
<div class="auth-wrap">
  <div class="auth-logo">₹</div>
  <p class="auth-title">FinApp</p>
  <p class="auth-sub">Create your account</p>

  <?php if (!empty($error)): ?>
    <div class="auth-error"><?= htmlspecialchars($error) ?></div>
  <?php endif; ?>

  <form method="post" autocomplete="on">
    <input type="hidden" name="form" value="register">
    <div class="form-group">
      <label for="name">Full Name</label>
      <input type="text" id="name" name="name" value="<?= htmlspecialchars($_POST['name'] ?? '') ?>" autofocus required autocomplete="name">
    </div>
    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" value="<?= htmlspecialchars($_POST['email'] ?? '') ?>" required autocomplete="email">
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input type="password" id="password" name="password" required autocomplete="new-password" minlength="8">
      <p class="hint">Minimum 8 characters</p>
    </div>
    <div class="form-group">
      <label for="confirm_password">Confirm Password</label>
      <input type="password" id="confirm_password" name="confirm_password" required autocomplete="new-password">
    </div>
    <button type="submit">Create Account</button>
  </form>

  <div class="auth-footer">
    Already have an account? <a href="?module=login">Sign in</a>
  </div>
</div>
</body>
</html>
