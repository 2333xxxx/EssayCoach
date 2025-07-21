// Enhanced animations and interactions
document.addEventListener('DOMContentLoaded', function() {
    
    // Progress bar animation
    function createProgressBar() {
        const progressBar = document.createElement('div');
        progressBar.className = 'md-progress';
        document.body.appendChild(progressBar);
        
        window.addEventListener('scroll', () => {
            const scrollTop = window.pageYOffset;
            const docHeight = document.body.scrollHeight - window.innerHeight;
            const scrollPercent = (scrollTop / docHeight) * 100;
            progressBar.style.width = scrollPercent + '%';
        });
    }
    
    // Smooth scroll to top
    function enhanceBackToTop() {
        const backToTop = document.querySelector('.md-top');
        if (backToTop) {
            backToTop.addEventListener('click', (e) => {
                e.preventDefault();
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });
        }
    }
    
    // Animated counters for stats
    function animateCounters() {
        const counters = document.querySelectorAll('.counter');
        counters.forEach(counter => {
            const target = parseInt(counter.getAttribute('data-target'));
            const increment = target / 100;
            let current = 0;
            
            const updateCounter = () => {
                if (current < target) {
                    current += increment;
                    counter.textContent = Math.ceil(current);
                    setTimeout(updateCounter, 20);
                } else {
                    counter.textContent = target;
                }
            };
            
            // Start animation when element is in view
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        updateCounter();
                        observer.unobserve(entry.target);
                    }
                });
            });
            
            observer.observe(counter);
        });
    }
    
    // Enhanced search with animation
    function enhanceSearch() {
        const searchInput = document.querySelector('.md-search__input');
        if (searchInput) {
            searchInput.addEventListener('focus', () => {
                searchInput.parentElement.classList.add('search-focused');
            });
            
            searchInput.addEventListener('blur', () => {
                searchInput.parentElement.classList.remove('search-focused');
            });
        }
    }
    
    // Parallax effect for headers
    function addParallaxEffect() {
        const headers = document.querySelectorAll('.md-typeset h1, .md-typeset h2');
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            headers.forEach(header => {
                const rate = scrolled * -0.5;
                header.style.transform = `translateY(${rate}px)`;
            });
        });
    }
    
    // Typing animation for code blocks
    function typeWriterEffect() {
        const codeBlocks = document.querySelectorAll('pre code');
        codeBlocks.forEach(block => {
            const text = block.textContent;
            let index = 0;
            
            const typeText = () => {
                if (index < text.length) {
                    block.textContent = text.substring(0, index + 1);
                    index++;
                    setTimeout(typeText, 10);
                }
            };
            
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        typeText();
                        observer.unobserve(entry.target);
                    }
                });
            });
            
            observer.observe(block);
        });
    }
    
    // Fade in animation for content
    function fadeInContent() {
        const contentElements = document.querySelectorAll('.md-content p, .md-content li, .md-content table');
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '0';
                    entry.target.style.transform = 'translateY(20px)';
                    entry.target.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                    
                    setTimeout(() => {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }, 100);
                    
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });
        
        contentElements.forEach(element => {
            observer.observe(element);
        });
    }
    
    // Ripple effect for buttons
    function addRippleEffect() {
        const buttons = document.querySelectorAll('.md-button');
        buttons.forEach(button => {
            button.addEventListener('click', (e) => {
                const ripple = document.createElement('span');
                const rect = button.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.width = ripple.style.height = size + 'px';
                ripple.style.left = x + 'px';
                ripple.style.top = y + 'px';
                ripple.classList.add('ripple');
                
                button.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });
    }
    
    // Keyboard shortcuts
    function addKeyboardShortcuts() {
        document.addEventListener('keydown', (e) => {
            // Ctrl/Cmd + K for search
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                const searchInput = document.querySelector('.md-search__input');
                if (searchInput) {
                    searchInput.focus();
                }
            }
            
            // Ctrl/Cmd + / for quick access to top
            if ((e.ctrlKey || e.metaKey) && e.key === '/') {
                e.preventDefault();
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            }
        });
    }
    
    // Initialize all enhancements
    createProgressBar();
    enhanceBackToTop();
    animateCounters();
    enhanceSearch();
    fadeInContent();
    addRippleEffect();
    addKeyboardShortcuts();
    addParallaxEffect();
    typeWriterEffect();
    
    // Add CSS for ripple effect
    const style = document.createElement('style');
    style.textContent = `
        .ripple {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.6);
            transform: scale(0);
            animation: ripple-animation 0.6s linear;
            pointer-events: none;
        }
        
        @keyframes ripple-animation {
            to {
                transform: scale(4);
                opacity: 0;
            }
        }
        
        .search-focused {
            transform: scale(1.02);
        }
        
        .counter {
            font-weight: bold;
            color: var(--primary-color);
        }
    `;
    document.head.appendChild(style);
});

// Add loading animation
window.addEventListener('load', () => {
    document.body.classList.add('loaded');
});

// Add smooth transitions between pages
document.addEventListener('DOMContentLoaded', function() {
    const links = document.querySelectorAll('a[href^="/"]');
    links.forEach(link => {
        link.addEventListener('click', (e) => {
            if (link.hostname === window.location.hostname) {
                e.preventDefault();
                document.body.style.opacity = '0.7';
                setTimeout(() => {
                    window.location.href = link.href;
                }, 200);
            }
        });
    });
});