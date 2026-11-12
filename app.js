/**
 * CASIO ROYALE AE-1200WH-1AV • APPLE-GRADE INTERACTIVE SCRIPT
 * Framer Motion Animation Engine • Zero-Button Hero Parallax • Live LCD System
 */

(function () {
  'use strict';

  // Global State
  const state = {
    soundEnabled: true,
    is24Hour: false,
    activeCity: 'DEL',
    cityTimezoneOffsets: {
      'UTC': 0,
      'LON': 0,
      'PAR': 1,
      'DXB': 4,
      'DEL': 5.5,
      'HKG': 8,
      'TYO': 9,
      'SYD': 11,
      'NYC': -5,
      'LAX': -8
    },
    cityMapZones: {
      'UTC': 'zone-eu',
      'LON': 'zone-eu',
      'PAR': 'zone-eu',
      'DXB': 'zone-me',
      'DEL': 'zone-asia',
      'HKG': 'zone-asia',
      'TYO': 'zone-asia',
      'SYD': 'zone-aus',
      'NYC': 'zone-na',
      'LAX': 'zone-na'
    },
    cartItems: 0,
    stopwatch: {
      running: false,
      startTime: 0,
      elapsedTime: 0,
      timerId: null
    },
    amberLightTimeout: null
  };

  // ==========================================================================
  // 0. BUTTER-SMOOTH APPLE-GRADE INERTIAL SCROLL ENGINE (LENIS)
  // ==========================================================================
  let lenis = null;

  function initLenisSmoothScroll() {
    if (typeof Lenis !== 'undefined') {
      lenis = new Lenis({
        duration: 1.25,
        easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
        orientation: 'vertical',
        gestureOrientation: 'vertical',
        smoothWheel: true,
        wheelMultiplier: 0.9,
        touchMultiplier: 1.5,
        infinite: false
      });

      // Synchronize Lenis with GSAP ScrollTrigger for 60fps locked momentum
      if (typeof gsap !== 'undefined' && typeof ScrollTrigger !== 'undefined') {
        lenis.on('scroll', ScrollTrigger.update);
        gsap.ticker.add((time) => {
          lenis.raf(time * 1000);
        });
        gsap.ticker.lagSmoothing(0);
      } else {
        function raf(time) {
          lenis.raf(time);
          requestAnimationFrame(raf);
        }
        requestAnimationFrame(raf);
      }
    }

    // Butter-smooth anchor scrolling for navigation links
    document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
      anchor.addEventListener('click', (e) => {
        const targetId = anchor.getAttribute('href');
        if (targetId && targetId !== '#') {
          const targetEl = document.querySelector(targetId);
          if (targetEl) {
            e.preventDefault();
            if (lenis) {
              lenis.scrollTo(targetEl, { offset: -60, duration: 1.3 });
            } else {
              targetEl.scrollIntoView({ behavior: 'smooth' });
            }
          }
        }
      });
    });
  }

  // ==========================================================================
  // 1. APPLE-STYLE FRAMER MOTION REVEAL ENGINE
  // ==========================================================================
  function initMotionEngine() {
    const reveals = document.querySelectorAll('.motion-reveal');
    
    const observerOptions = {
      root: null,
      rootMargin: '0px 0px -12% 0px',
      threshold: 0.15
    };

    const revealObserver = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('in-view');
        }
      });
    }, observerOptions);

    reveals.forEach((el) => revealObserver.observe(el));

    // ========================================================================
    // POP-UP ANIMATION ENGINE FOR [SPECIFICATIONS & PRICE] BOXES 1, 2, 3, 4, 5, 6
    // ========================================================================
    const specBoxes = document.querySelectorAll('.spec-box-popup');
    if (specBoxes.length > 0) {
      const specObserverOptions = {
        root: null,
        rootMargin: '0px 0px -8% 0px',
        threshold: 0.12
      };

      const specObserver = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('popped-up');
          }
        });
      }, specObserverOptions);

      specBoxes.forEach((box) => {
        specObserver.observe(box);

        // Interactive Audio Feedback on Spec Box Hover
        box.addEventListener('mouseenter', () => {
          playCasioBeep(3600, 0.02, 'sine');
        });
      });
    }

    // Apple-Style Scroll Text Lighting (Scrub Text Highlighter with Smooth Lerp)
    const scrubTexts = document.querySelectorAll('.scrub-text-light');
    if (scrubTexts.length > 0) {
      window.addEventListener('scroll', () => {
        const winH = window.innerHeight;
        requestAnimationFrame(() => {
          scrubTexts.forEach((el) => {
            const rect = el.getBoundingClientRect();
            const elementCenter = rect.top + rect.height / 2;
            const progress = Math.max(0, Math.min(1, (winH - elementCenter) / (winH * 0.75)));
            el.style.setProperty('--text-fill', `${(progress * 100).toFixed(1)}%`);
          });
        });
      }, { passive: true });
    }
  }

  // ==========================================================================
  // 2. WEB AUDIO API SYNTHESIZER (CASIO HARDWARE TONES)
  // ==========================================================================
  let audioCtx = null;

  function initAudio() {
    if (!audioCtx) {
      const AudioContextClass = window.AudioContext || window.webkitAudioContext;
      if (AudioContextClass) {
        audioCtx = new AudioContextClass();
      }
    }
    if (audioCtx && audioCtx.state === 'suspended') {
      audioCtx.resume();
    }
  }

  function playCasioBeep(freq = 4000, duration = 0.05, type = 'square') {
    if (!state.soundEnabled) return;
    try {
      initAudio();
      if (!audioCtx) return;

      const osc = audioCtx.createOscillator();
      const gain = audioCtx.createGain();

      osc.type = type;
      osc.frequency.setValueAtTime(freq, audioCtx.currentTime);

      gain.gain.setValueAtTime(0.04, audioCtx.currentTime);
      gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + duration);

      osc.connect(gain);
      gain.connect(audioCtx.destination);

      osc.start();
      osc.stop(audioCtx.currentTime + duration);
    } catch (e) {}
  }

  function playCasioDoubleBeep() {
    playCasioBeep(4000, 0.04);
    setTimeout(() => playCasioBeep(4000, 0.04), 80);
  }

  // ==========================================================================
  // 3. AMBIENT ZERO-G STARDUST CANVAS
  // ==========================================================================
  function initSpaceParticles() {
    const canvas = document.getElementById('space-canvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    let width = (canvas.width = window.innerWidth);
    let height = (canvas.height = window.innerHeight);

    window.addEventListener('resize', () => {
      width = canvas.width = window.innerWidth;
      height = canvas.height = window.innerHeight;
    });

    const particles = [];
    const count = Math.min(70, Math.floor(width / 20));

    for (let i = 0; i < count; i++) {
      particles.push({
        x: Math.random() * width,
        y: Math.random() * height,
        radius: Math.random() * 1.5 + 0.5,
        baseAlpha: Math.random() * 0.4 + 0.1,
        vx: (Math.random() - 0.5) * 0.18,
        vy: (Math.random() - 0.5) * 0.18,
        isAmber: Math.random() > 0.7
      });
    }

    let mouseX = width / 2;
    let mouseY = height / 2;

    window.addEventListener('mousemove', (e) => {
      mouseX = e.clientX;
      mouseY = e.clientY;
    });

    function renderParticles() {
      ctx.clearRect(0, 0, width, height);

      particles.forEach((p) => {
        p.x += p.vx;
        p.y += p.vy;

        if (p.x < 0) p.x = width;
        if (p.x > width) p.x = 0;
        if (p.y < 0) p.y = height;
        if (p.y > height) p.y = 0;

        const dx = p.x - mouseX;
        const dy = p.y - mouseY;
        const dist = Math.sqrt(dx * dx + dy * dy);
        let alpha = p.baseAlpha;
        if (dist < 180) {
          alpha = p.baseAlpha + (1 - dist / 180) * 0.4;
        }

        ctx.beginPath();
        ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
        ctx.fillStyle = p.isAmber
          ? `rgba(245, 158, 11, ${alpha})`
          : `rgba(226, 232, 240, ${alpha * 0.7})`;
        ctx.fill();
      });

      requestAnimationFrame(renderParticles);
    }

    renderParticles();
  }

  // ==========================================================================
  // 4. HERO SCROLL-DRIVEN 147-FRAME SEQUENCE (APPLE KEYNOTE SCRUB)
  // ==========================================================================
  function initHeroSequenceScrub() {
    const container = document.getElementById('hero-sequence-container');
    const canvas = document.getElementById('hero-sequence-canvas');
    if (!container || !canvas) return;

    const stickyContainer = container.querySelector('.hero-sequence-sticky');
    const ctx = canvas.getContext('2d');
    const frameCount = 147;
    const images = [];
    let loadedCount = 0;
    let currentRenderedIndex = -1;

    const loader = document.getElementById('canvas-loader');
    const loaderFill = document.getElementById('canvas-loader-fill');
    const scrollCue = document.getElementById('hero-scroll-cue');

    const step1 = document.getElementById('hero-step-1');
    const step2 = document.getElementById('hero-step-2');
    const step3 = document.getElementById('hero-step-3');
    const step4 = document.getElementById('hero-step-4');

    function resizeCanvas() {
      const dpr = Math.min(window.devicePixelRatio || 1, 2);
      canvas.width = window.innerWidth * dpr;
      canvas.height = window.innerHeight * dpr;
      if (currentRenderedIndex >= 0) {
        renderFrame(currentRenderedIndex);
      }
    }

    window.addEventListener('resize', resizeCanvas);
    resizeCanvas();

    function getFrameUrl(index) {
      const num = String(index + 1).padStart(3, '0');
      return `public/images/herosection/ezgif-frame-${num}.png`;
    }

    function renderFrame(index) {
      const img = images[index];
      if (!img || !img.complete || img.naturalWidth === 0) return;

      currentRenderedIndex = index;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const hRatio = canvas.width / img.width;
      const vRatio = canvas.height / img.height;
      const ratio = Math.min(hRatio, vRatio);

      const drawW = img.width * ratio;
      const drawH = img.height * ratio;
      const drawX = (canvas.width - drawW) / 2;
      const drawY = (canvas.height - drawH) / 2;

      ctx.drawImage(img, 0, 0, img.width, img.height, drawX, drawY, drawW, drawH);
    }

    for (let i = 0; i < frameCount; i++) {
      const img = new Image();
      img.src = getFrameUrl(i);
      img.onload = () => {
        loadedCount++;
        if (loaderFill) {
          loaderFill.style.width = `${((loadedCount / frameCount) * 100).toFixed(0)}%`;
        }
        if (i === 0 && currentRenderedIndex === -1) {
          renderFrame(0);
        }
        if (loadedCount === frameCount && loader) {
          loader.classList.add('loaded');
        }
      };
      images.push(img);
    }

    let isTicking = false;
    function updateSequence(progress) {
      const clampedP = Math.max(0, Math.min(1, progress));

      // 1. Keep Watch Centered (Sticky) & Slow Down Scroll Scrub:
      // The 147 frames scrub smoothly from 0 to 146 across progress 0.0 to 0.86
      // (With container height at 500vh + Lenis momentum, this provides an ultra-luxurious, cinematic scrub)
      const animProgress = Math.min(1, clampedP / 0.86);
      const targetIndex = Math.min(frameCount - 1, Math.floor(animProgress * (frameCount - 1)));

      // 2. Smooth Fade-Out Exit for the Watch (86% to 100% scroll progress):
      // Once the exploded watch animation finishes, smoothly fade out both
      // the canvas and the sticky container (opacity 1 to 0) as details-price scrolls up.
      let watchOpacity = 1;
      if (clampedP > 0.86) {
        watchOpacity = Math.max(0, 1 - (clampedP - 0.86) / 0.14);
      }

      if (!isTicking) {
        isTicking = true;
        requestAnimationFrame(() => {
          if (targetIndex !== currentRenderedIndex) {
            renderFrame(targetIndex);
          }
          canvas.style.opacity = watchOpacity.toFixed(3);
          if (stickyContainer) {
            stickyContainer.style.opacity = watchOpacity.toFixed(3);
            stickyContainer.style.pointerEvents = watchOpacity <= 0 ? 'none' : 'auto';
          }
          isTicking = false;
        });
      }

      if (scrollCue) {
        scrollCue.style.opacity = clampedP > 0.05 ? '0' : '1';
      }

      const textOverlay = document.querySelector('.hero-text-overlay');
      if (textOverlay) {
        textOverlay.style.opacity = watchOpacity.toFixed(3);
      }

      // Feature text steps smoothly fading in/out across the scrub with extended runway
      if (step1) {
        if (clampedP < 0.22) {
          step1.classList.add('active');
        } else {
          step1.classList.remove('active');
        }
      }

      if (step2) {
        if (clampedP >= 0.24 && clampedP < 0.46) {
          step2.classList.add('active');
        } else {
          step2.classList.remove('active');
        }
      }

      if (step3) {
        if (clampedP >= 0.48 && clampedP < 0.70) {
          step3.classList.add('active');
        } else {
          step3.classList.remove('active');
        }
      }

      if (step4) {
        if (clampedP >= 0.72 && clampedP <= 0.86) {
          step4.classList.add('active');
        } else {
          step4.classList.remove('active');
        }
      }
    }

    if (typeof gsap !== 'undefined' && typeof ScrollTrigger !== 'undefined') {
      gsap.registerPlugin(ScrollTrigger);
      ScrollTrigger.create({
        trigger: container,
        start: 'top top',
        end: 'bottom bottom',
        scrub: 1.0, // Apple-style fluid momentum scrub
        onUpdate: (self) => updateSequence(self.progress),
        onLeave: () => updateSequence(1),
        onEnterBack: () => updateSequence(1)
      });
    } else {
      window.addEventListener('scroll', () => {
        const rect = container.getBoundingClientRect();
        const scrollDist = container.offsetHeight - window.innerHeight;
        if (scrollDist <= 0) return;
        const progress = -rect.top / scrollDist;
        updateSequence(progress);
      }, { passive: true });
    }
  }



  // ==========================================================================
  // 6. LIVE INTERACTIVE AE-1200 LCD DISPLAY ENGINE
  // ==========================================================================
  function initLCDEngine() {
    const radarHourHand = document.getElementById('lcd-radar-hour');
    const radarMinHand = document.getElementById('lcd-radar-min');
    const timeDisplay = document.getElementById('lcd-time-main');
    const secDisplay = document.getElementById('lcd-time-sec');
    const pmDisplay = document.getElementById('lcd-am-pm');
    const dateDisplay = document.getElementById('lcd-date-display');
    const cityCodeDisplay = document.getElementById('lcd-city-code');
    const cityPills = document.querySelectorAll('.city-pill');
    const mapZones = document.querySelectorAll('.world-map-svg path');
    const lcdScreen = document.getElementById('interactive-lcd-screen');
    const lightButton = document.getElementById('btn-lcd-light');

    if (!timeDisplay) return;

    function getCityTime(offset) {
      const now = new Date();
      const utc = now.getTime() + now.getTimezoneOffset() * 60000;
      return new Date(utc + 3600000 * offset);
    }

    function updateLCDClock() {
      const offset = state.cityTimezoneOffsets[state.activeCity] || 0;
      const cityDate = getCityTime(offset);

      const hours = cityDate.getHours();
      const minutes = cityDate.getMinutes();
      const seconds = cityDate.getSeconds();
      const isPM = hours >= 12;

      let displayHours = hours;
      if (!state.is24Hour) {
        displayHours = hours % 12 === 0 ? 12 : hours % 12;
      }
      const formattedHours = displayHours < 10 ? `0${displayHours}` : `${displayHours}`;
      const formattedMin = minutes < 10 ? `0${minutes}` : `${minutes}`;
      const formattedSec = seconds < 10 ? `0${seconds}` : `${seconds}`;

      if (timeDisplay) timeDisplay.textContent = `${formattedHours}:${formattedMin}`;
      if (secDisplay) secDisplay.textContent = formattedSec;
      if (pmDisplay) pmDisplay.textContent = state.is24Hour ? '24H' : (isPM ? 'PM' : 'AM');

      const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
      const dayStr = days[cityDate.getDay()];
      const month = cityDate.getMonth() + 1;
      const dateNum = cityDate.getDate();
      const formattedDate = `${month < 10 ? '0' + month : month}-${dateNum < 10 ? '0' + dateNum : dateNum}`;

      if (dateDisplay) dateDisplay.textContent = `${dayStr}  ${formattedDate}`;

      if (radarHourHand && radarMinHand) {
        const hourDeg = (hours % 12 + minutes / 60) * 30;
        const minDeg = (minutes + seconds / 60) * 6;
        radarHourHand.style.transform = `rotate(${hourDeg}deg)`;
        radarMinHand.style.transform = `rotate(${minDeg}deg)`;
      }
    }

    function setCity(cityCode) {
      state.activeCity = cityCode;
      playCasioBeep(4200, 0.05);

      if (cityCodeDisplay) {
        const offsetVal = state.cityTimezoneOffsets[cityCode];
        const offsetSign = offsetVal >= 0 ? `+${offsetVal}` : `${offsetVal}`;
        cityCodeDisplay.textContent = `${cityCode} UTC${offsetSign}`;
      }

      cityPills.forEach((pill) => {
        if (pill.dataset.city === cityCode) {
          pill.classList.add('active');
        } else {
          pill.classList.remove('active');
        }
      });

      const activeZoneId = state.cityMapZones[cityCode];
      mapZones.forEach((path) => {
        if (path.id === activeZoneId) {
          path.classList.add('map-zone-active');
        } else {
          path.classList.remove('map-zone-active');
        }
      });

      updateLCDClock();
    }

    cityPills.forEach((pill) => {
      pill.addEventListener('click', () => setCity(pill.dataset.city));
    });

    function triggerAmberLight() {
      if (!lcdScreen) return;
      playCasioBeep(4800, 0.04);

      if (state.amberLightTimeout) clearTimeout(state.amberLightTimeout);
      lcdScreen.classList.add('amber-active');

      state.amberLightTimeout = setTimeout(() => {
        lcdScreen.classList.remove('amber-active');
      }, 2500);
    }

    if (lightButton) lightButton.addEventListener('click', triggerAmberLight);

    const bezelLightBtn = document.getElementById('bezel-btn-light');
    if (bezelLightBtn) bezelLightBtn.addEventListener('click', triggerAmberLight);

    const bezelSearchBtn = document.getElementById('bezel-btn-search');
    if (bezelSearchBtn) {
      const cityList = ['UTC', 'LON', 'PAR', 'DXB', 'DEL', 'HKG', 'TYO', 'SYD', 'NYC', 'LAX'];
      bezelSearchBtn.addEventListener('click', () => {
        const currIndex = cityList.indexOf(state.activeCity);
        const nextIndex = (currIndex + 1) % cityList.length;
        setCity(cityList[nextIndex]);
      });
    }

    const bezelAdjustBtn = document.getElementById('bezel-btn-adjust');
    if (bezelAdjustBtn) {
      bezelAdjustBtn.addEventListener('click', () => {
        state.is24Hour = !state.is24Hour;
        playCasioDoubleBeep();
        updateLCDClock();
      });
    }

    const bezelModeBtn = document.getElementById('bezel-btn-mode');
    if (bezelModeBtn) {
      bezelModeBtn.addEventListener('click', () => {
        playCasioBeep(3500, 0.04);
        setTimeout(() => playCasioBeep(4500, 0.04), 60);
      });
    }

    setCity('DEL');
    setInterval(updateLCDClock, 1000);
  }

  // ==========================================================================
  // 7. LIVE INTERACTIVE STOPWATCH BENTO CARD
  // ==========================================================================
  function initStopwatchCard() {
    const swDisplay = document.getElementById('sw-card-display');
    const startBtn = document.getElementById('sw-btn-start');
    const splitBtn = document.getElementById('sw-btn-split');
    const resetBtn = document.getElementById('sw-btn-reset');

    if (!swDisplay || !startBtn) return;

    function formatTime(ms) {
      const minutes = Math.floor(ms / 60000);
      const seconds = Math.floor((ms % 60000) / 1000);
      const centiseconds = Math.floor((ms % 1000) / 10);
      const m = minutes < 10 ? `0${minutes}` : `${minutes}`;
      const s = seconds < 10 ? `0${seconds}` : `${seconds}`;
      const cs = centiseconds < 10 ? `0${centiseconds}` : `${centiseconds}`;
      return `${m}:${s}.${cs}`;
    }

    function update() {
      const current = performance.now();
      const delta = current - state.stopwatch.startTime;
      const total = state.stopwatch.elapsedTime + delta;
      swDisplay.textContent = formatTime(total);

      if (state.stopwatch.running) {
        state.stopwatch.timerId = requestAnimationFrame(update);
      }
    }

    startBtn.addEventListener('click', () => {
      playCasioBeep(4000, 0.05);
      if (!state.stopwatch.running) {
        state.stopwatch.running = true;
        state.stopwatch.startTime = performance.now();
        startBtn.textContent = 'STOP';
        startBtn.classList.remove('bg-amber-500', 'text-black');
        startBtn.classList.add('bg-red-500', 'text-white');
        update();
      } else {
        state.stopwatch.running = false;
        state.stopwatch.elapsedTime += performance.now() - state.stopwatch.startTime;
        cancelAnimationFrame(state.stopwatch.timerId);
        startBtn.textContent = 'START';
        startBtn.classList.remove('bg-red-500', 'text-white');
        startBtn.classList.add('bg-amber-500', 'text-black');
      }
    });

    splitBtn.addEventListener('click', () => {
      playCasioBeep(3500, 0.04);
      swDisplay.style.opacity = '0.3';
      setTimeout(() => (swDisplay.style.opacity = '1'), 120);
    });

    resetBtn.addEventListener('click', () => {
      playCasioDoubleBeep();
      state.stopwatch.running = false;
      state.stopwatch.startTime = 0;
      state.stopwatch.elapsedTime = 0;
      cancelAnimationFrame(state.stopwatch.timerId);
      swDisplay.textContent = '00:00.00';
      startBtn.textContent = 'START';
      startBtn.classList.remove('bg-red-500', 'text-white');
      startBtn.classList.add('bg-amber-500', 'text-black');
    });
  }

  // ==========================================================================
  // 8. WATER RESISTANCE INTERACTIVE DEPTH SLIDER
  // ==========================================================================
  function initWaterResistanceCard() {
    const slider = document.getElementById('water-depth-slider');
    const depthReadout = document.getElementById('water-depth-val');
    const barReadout = document.getElementById('water-bar-val');
    const wave = document.querySelector('.water-wave');

    if (!slider || !depthReadout) return;

    slider.addEventListener('input', (e) => {
      const depth = parseInt(e.target.value, 10);
      const bars = (depth / 10).toFixed(1);
      depthReadout.textContent = `${depth}m`;
      if (barReadout) barReadout.textContent = `${bars} BAR`;
      if (wave) {
        wave.style.opacity = 0.2 + (depth / 100) * 0.5;
        wave.style.animationDuration = `${12 - (depth / 100) * 7}s`;
      }
    });
  }

  // ==========================================================================
  // 9. COMMERCE & MODALS (IN DETAILS SECTION & MODALS)
  // ==========================================================================
  function initModals() {
    const cartOverlay = document.getElementById('cart-drawer-overlay');
    const cartDrawer = document.getElementById('cart-drawer');
    const btnOpenCart = document.getElementById('btn-open-cart');
    const btnCloseCart = document.getElementById('btn-close-cart');
    const btnAddToCart = document.querySelectorAll('.btn-add-to-cart');
    const cartBadge = document.querySelectorAll('.cart-item-count');

    const checkoutModal = document.getElementById('checkout-modal');
    const btnBuyNow = document.querySelectorAll('.btn-buy-now');
    const btnCloseCheckout = document.getElementById('btn-close-checkout');

    const storeModal = document.getElementById('store-modal');
    const btnFindStore = document.querySelectorAll('.btn-find-store');
    const btnCloseStore = document.getElementById('btn-close-store');

    btnAddToCart.forEach((btn) => {
      btn.addEventListener('click', () => {
        playCasioDoubleBeep();
        state.cartItems += 1;
        cartBadge.forEach((badge) => {
          badge.textContent = state.cartItems;
          badge.classList.remove('hidden');
        });
        if (cartOverlay && cartDrawer) {
          cartOverlay.classList.add('active');
          cartDrawer.classList.add('active');
        }
      });
    });

    function closeCart() {
      if (cartOverlay && cartDrawer) {
        cartOverlay.classList.remove('active');
        cartDrawer.classList.remove('active');
      }
    }

    if (btnCloseCart) btnCloseCart.addEventListener('click', closeCart);
    if (btnOpenCart) {
      btnOpenCart.addEventListener('click', () => {
        playCasioBeep(3800, 0.05);
        if (cartOverlay && cartDrawer) {
          cartOverlay.classList.add('active');
          cartDrawer.classList.add('active');
        }
      });
    }

    btnBuyNow.forEach((btn) => {
      btn.addEventListener('click', () => {
        playCasioDoubleBeep();
        closeCart();
        if (checkoutModal) checkoutModal.classList.add('active');
      });
    });

    if (btnCloseCheckout) {
      btnCloseCheckout.addEventListener('click', () => {
        playCasioBeep(3000, 0.04);
        if (checkoutModal) checkoutModal.classList.remove('active');
      });
    }

    btnFindStore.forEach((btn) => {
      btn.addEventListener('click', () => {
        playCasioBeep(3800, 0.05);
        if (storeModal) storeModal.classList.add('active');
      });
    });

    if (btnCloseStore) {
      btnCloseStore.addEventListener('click', () => {
        playCasioBeep(3000, 0.04);
        if (storeModal) storeModal.classList.remove('active');
      });
    }

    if (cartOverlay) {
      cartOverlay.addEventListener('click', (e) => {
        if (e.target === cartOverlay) {
          closeCart();
          if (checkoutModal) checkoutModal.classList.remove('active');
          if (storeModal) storeModal.classList.remove('active');
        }
      });
    }

    // Audio Toggle in Header
    const soundToggle = document.getElementById('sound-toggle-btn');
    if (soundToggle) {
      soundToggle.addEventListener('click', () => {
        state.soundEnabled = !state.soundEnabled;
        if (state.soundEnabled) {
          playCasioDoubleBeep();
          soundToggle.classList.add('text-amber-400');
          soundToggle.classList.remove('text-neutral-500');
        } else {
          soundToggle.classList.remove('text-amber-400');
          soundToggle.classList.add('text-neutral-500');
        }
      });
    }
  }

  // ==========================================================================
  // ENTRY POINT
  // ==========================================================================
  document.addEventListener('DOMContentLoaded', () => {
    initLenisSmoothScroll();
    initMotionEngine();
    initSpaceParticles();
    initHeroSequenceScrub();
    initLCDEngine();
    initStopwatchCard();
    initWaterResistanceCard();
    initModals();
  });
})();
