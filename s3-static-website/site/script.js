// Mobile menu + theme toggle + year stamp
const menuBtn = document.querySelector('.menu-btn');
const nav = document.getElementById('nav');
if (menuBtn && nav) {
  menuBtn.addEventListener('click', () => {
    const open = nav.classList.toggle('open');
    menuBtn.setAttribute('aria-expanded', String(open));
  });
}

const yearEl = document.getElementById('year');
if (yearEl) yearEl.textContent = new Date().getFullYear();

const themeToggle = document.getElementById('themeToggle');
if (themeToggle) {
  const key = 'pref-theme';
  const apply = (t) => document.documentElement.dataset.theme = t;
  const saved = localStorage.getItem(key);
  if (saved) apply(saved);
  themeToggle.addEventListener('click', () => {
    const next = (document.documentElement.dataset.theme === 'light') ? 'dark' :
                 (document.documentElement.dataset.theme === 'dark') ? 'auto' : 'light';
    if (next === 'auto') localStorage.removeItem(key); else localStorage.setItem(key, next);
    apply(next);
  });
}
