(function () {
  const header = document.querySelector('.site-header');
  const navToggle = document.querySelector('.nav-toggle');
  const navMobile = document.querySelector('.nav-mobile');
  const navLinks = document.querySelectorAll('.nav-desktop a, .nav-mobile a');

  // Sticky header shadow
  function onScroll() {
    if (!header) return;
    header.classList.toggle('scrolled', window.scrollY > 8);
  }

  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();

  // Mobile nav
  if (navToggle && navMobile) {
    navToggle.addEventListener('click', () => {
      const open = navMobile.classList.toggle('open');
      navToggle.setAttribute('aria-expanded', String(open));
    });

    navMobile.querySelectorAll('a').forEach((link) => {
      link.addEventListener('click', () => {
        navMobile.classList.remove('open');
        navToggle.setAttribute('aria-expanded', 'false');
      });
    });
  }

  // Active nav link on scroll
  const sections = [...document.querySelectorAll('section[id]')];

  function setActiveNav() {
    const scrollPos = window.scrollY + 120;
    let current = '';

    sections.forEach((section) => {
      if (section.offsetTop <= scrollPos) {
        current = section.getAttribute('id') || '';
      }
    });

    navLinks.forEach((link) => {
      const href = link.getAttribute('href') || '';
      if (href.startsWith('#') && href.slice(1) === current) {
        link.classList.add('active');
      } else if (href.startsWith('#')) {
        link.classList.remove('active');
      }
    });
  }

  if (sections.length) {
    window.addEventListener('scroll', setActiveNav, { passive: true });
    setActiveNav();
  }

  // Scroll reveal
  const revealEls = document.querySelectorAll('.reveal');

  if (revealEls.length && 'IntersectionObserver' in window) {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            observer.unobserve(entry.target);
          }
        });
      },
      { threshold: 0.12, rootMargin: '0px 0px -40px 0px' }
    );

    revealEls.forEach((el) => observer.observe(el));
  } else {
    revealEls.forEach((el) => el.classList.add('visible'));
  }
})();
