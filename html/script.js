const icons = {
    warning: `<img src="icons/warning.png" alt="Warning" style="width: 100%; height: 100%; object-fit: contain;">`,
    success: `<img src="icons/success.png" alt="Success" style="width: 100%; height: 100%; object-fit: contain;">`,
    error: `<img src="icons/error.png" alt="Error" style="width: 100%; height: 100%; object-fit: contain;">`,
    system: `<img src="icons/system.png" alt="System" style="width: 100%; height: 100%; object-fit: contain;">`
};

let soundEnabled = true;
let currentPosition = { x: 30, y: 30 };
let isDragging = false;
let dragOffset = { x: 0, y: 0 };

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'notify') {
        showNotification(data.type, data.title, data.message, data.sound);
    } else if (data.action === 'setTheme') {
        document.body.setAttribute('data-theme', data.theme);
        updateThemeSelection(data.theme);
    } else if (data.action === 'setSound') {
        soundEnabled = data.enabled;
        updateSoundToggle(data.enabled);
    } else if (data.action === 'setPosition') {
        currentPosition = { x: data.x, y: data.y };
        updateContainerPosition(data.x, data.y);
    } else if (data.action === 'openSettings') {
        openSettingsPanel(data.currentTheme, data.soundEnabled, data.position);
    } else if (data.action === 'closeSettings') {
        // Force close from Lua side
        const panel = document.getElementById('settings-panel');
        const adjuster = document.getElementById('position-adjuster');
        panel.classList.add('hidden');
        adjuster.classList.add('hidden');
        document.body.classList.remove('nui-visible');
        document.body.classList.add('nui-hidden');
    }
});

function showNotification(type, title, message, playSound = true) {
    const container = document.getElementById('notifications-container');
    const el = document.createElement('div');
    
    // Fallback to system icon if invalid type
    const safeType = icons[type] ? type : 'system';
    
    el.className = `notification ${safeType}`;
    el.innerHTML = `
        <div class="icon-container">
            ${icons[safeType]}
        </div>
        <div class="text-container">
            <div class="title">${title}</div>
            <div class="message">${message}</div>
        </div>
    `;

    container.appendChild(el);

    // Play notification sound
    if (playSound && soundEnabled) {
        const audio = document.getElementById('notification-sound');
        audio.currentTime = 0;
        audio.volume = 0.5;
        audio.play().catch(err => {});
    }

    // Remove notification after 5 seconds
    setTimeout(() => {
        el.classList.add('hiding');
        el.addEventListener('animationend', () => {
            el.remove();
        });
    }, 5000);
}

function updateContainerPosition(x, y) {
    const container = document.getElementById('notifications-container');
    container.style.top = `${y}px`;
    container.style.right = `${x}px`;
}

// Settings Panel Functions
function openSettingsPanel(theme, sound, position) {
    const panel = document.getElementById('settings-panel');
    panel.classList.remove('hidden');
    document.body.classList.add('nui-visible');
    document.body.classList.remove('nui-hidden');
    updateThemeSelection(theme);
    updateSoundToggle(sound);
    soundEnabled = sound; // Update the soundEnabled state
    currentPosition = position;
}

function closeSettings() {
    const panel = document.getElementById('settings-panel');
    panel.classList.add('hidden');
    document.body.classList.remove('nui-visible');
    document.body.classList.add('nui-hidden');
    
    // Send callback to Lua to disable NUI focus
    fetch(`https://${GetParentResourceName()}/closeSettings`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    }).catch(err => {});
}

function selectTheme(theme) {
    document.body.setAttribute('data-theme', theme);
    updateThemeSelection(theme);
    fetch(`https://${GetParentResourceName()}/updateTheme`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ theme: theme })
    });
    
    // Show preview notification
    showNotification('success', 'Theme Changed', `Switched to ${theme.charAt(0).toUpperCase() + theme.slice(1)} theme`, false);
}

function updateThemeSelection(theme) {
    document.querySelectorAll('.theme-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.getAttribute('data-theme') === theme) {
            btn.classList.add('active');
        }
    });
}

function toggleSound(enabled) {
    soundEnabled = enabled;
    fetch(`https://${GetParentResourceName()}/updateSound`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ enabled: enabled })
    });
    
    // Show preview notification with sound based on toggle state
    if (enabled) {
        showNotification('system', 'Sound Enabled', 'Notification sounds are now active', true);
    } else {
        showNotification('warning', 'Sound Disabled', 'Notification sounds are now muted', false);
    }
}

function updateSoundToggle(enabled) {
    const toggle = document.getElementById('sound-toggle');
    if (toggle) {
        toggle.checked = enabled;
    }
}

// Position Adjuster Functions
function openPositionAdjuster() {
    const adjuster = document.getElementById('position-adjuster');
    const preview = document.getElementById('draggable-preview');
    adjuster.classList.remove('hidden');
    
    // Set preview to current position
    preview.style.top = `${currentPosition.y}px`;
    preview.style.right = `${currentPosition.x}px`;
    
    // Initialize dragging
    initDragging();
}

function cancelPositionAdjuster() {
    const adjuster = document.getElementById('position-adjuster');
    adjuster.classList.add('hidden');
}

function savePosition() {
    const preview = document.getElementById('draggable-preview');
    const rect = preview.getBoundingClientRect();
    const x = Math.floor(window.innerWidth - rect.right);
    const y = Math.floor(rect.top);
    
    fetch(`https://${GetParentResourceName()}/savePosition`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ x: x, y: y })
    });
    
    cancelPositionAdjuster();
    
    // Close settings after saving position
    setTimeout(() => {
        closeSettings();
    }, 100);
}

function initDragging() {
    const preview = document.getElementById('draggable-preview');
    
    preview.addEventListener('mousedown', function(e) {
        isDragging = true;
        const rect = preview.getBoundingClientRect();
        dragOffset.x = e.clientX - rect.left;
        dragOffset.y = e.clientY - rect.top;
        preview.style.cursor = 'grabbing';
    });
    
    document.addEventListener('mousemove', function(e) {
        if (isDragging) {
            const x = e.clientX - dragOffset.x;
            const y = e.clientY - dragOffset.y;
            
            // Constrain to viewport
            const maxX = window.innerWidth - preview.offsetWidth;
            const maxY = window.innerHeight - preview.offsetHeight;
            
            const constrainedX = Math.max(0, Math.min(x, maxX));
            const constrainedY = Math.max(0, Math.min(y, maxY));
            
            preview.style.left = `${constrainedX}px`;
            preview.style.top = `${constrainedY}px`;
            preview.style.right = 'auto';
        }
    });
    
    document.addEventListener('mouseup', function() {
        if (isDragging) {
            isDragging = false;
            preview.style.cursor = 'grab';
        }
    });
}

// ESC key to close settings
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        const settingsPanel = document.getElementById('settings-panel');
        const positionAdjuster = document.getElementById('position-adjuster');
        
        if (!positionAdjuster.classList.contains('hidden')) {
            // Close position adjuster and return to settings
            cancelPositionAdjuster();
        } else if (!settingsPanel.classList.contains('hidden')) {
            // Close settings completely
            closeSettings();
        }
    }
});

function GetParentResourceName() {
    const hostname = window.location.hostname;
    // Remove 'cfx-nui-' prefix if present
    if (hostname.startsWith('cfx-nui-')) {
        return hostname.replace('cfx-nui-', '');
    }
    // If empty (testing in browser), use fallback
    return hostname !== '' ? hostname : 'herd_notifications';
}
