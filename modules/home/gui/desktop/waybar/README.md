# Waybar Theme Configuration

This module provides a comprehensive waybar configuration that maintains visual consistency with Hyprland and Stylix theming using the Catppuccin Mocha color palette.

## Overview

The waybar configuration is designed to:
- Match the Catppuccin Mocha theme used throughout the system
- Complement the Hyprland window manager styling
- Integrate seamlessly with Stylix automatic theming
- Provide a modern, animated, and responsive status bar experience

## Color Palette

The configuration uses the Catppuccin Mocha color scheme with the following key colors:

| Color | Hex Code | Usage |
|-------|----------|-------|
| Base | `#1e1e2e` | Background, dark text |
| Mantle | `#181825` | Secondary backgrounds |
| Surface0 | `#313244` | Module backgrounds |
| Surface1 | `#45475a` | Hover states |
| Surface2 | `#585b70` | Muted text, borders |
| Text | `#cdd6f4` | Primary text color |
| Mauve | `#cba6f7` | Active workspace, accents |
| Blue | `#89b4fa` | CPU indicator |
| Green | `#a6e3a1` | Memory, battery good |
| Teal | `#94e2d5` | Network indicator |
| Yellow | `#f9e2af` | Temperature, warnings |
| Peach | `#fab387` | Audio indicator |
| Red | `#f38ba8` | Critical states, urgent |

## Features

### Workspaces
- **Hyprland Integration**: Direct workspace switching and status
- **Visual States**: Active, urgent, and default workspace styling
- **Icons**: Custom Nerd Font icons for workspace numbers
- **Animations**: Smooth hover and state transitions

### System Monitoring
- **CPU Usage**: Real-time CPU percentage with warning states
- **Memory Usage**: RAM usage with detailed tooltip information
- **Temperature**: System temperature monitoring with critical alerts
- **Battery**: Battery level, charging status, and time estimates
- **Network**: WiFi/Ethernet status with connection details

### Audio & Media
- **PulseAudio**: Volume control with mute detection
- **Icons**: Context-aware audio device icons
- **Integration**: Direct pavucontrol access on click

### Window Management
- **Active Window**: Shows current window title with app icons
- **Submap**: Displays active Hyprland keybind submaps
- **Tray**: System tray with attention states

### Clock & Calendar
- **Time Display**: 24-hour format with date alternative
- **Calendar**: Interactive calendar with Catppuccin styling
- **Timezone**: Configurable timezone support

## File Structure

```
waybar/
├── default.nix          # Main module configuration
├── config/
│   ├── config.jsonc     # Waybar JSON configuration
│   └── style.css        # Custom CSS styling
└── README.md           # This documentation
```

## Consistency with Other Components

### Hyprland Integration
- **Border Colors**: Matches Hyprland's active border gradient (`cba6f7` → `f2cdcd`)
- **Opacity**: Consistent opacity settings with window decorations
- **Gaps**: Respects Hyprland's gap settings in positioning

### Stylix Integration
- **Font Family**: Uses Stylix-configured fonts (Ubuntu, Font Awesome)
- **Font Sizes**: Matches Stylix application font sizes
- **Base16 Colors**: Directly uses Stylix base16 color overrides
- **Automatic Updates**: Theme updates when Stylix configuration changes

## Dependencies

The module automatically installs required packages:
- `waybar` - The status bar application
- `font-awesome` - Icon fonts for modules
- `pavucontrol` - Audio control GUI
- `networkmanagerapplet` - Network management tools

## Customization

### Modifying Colors
Colors are defined in the CSS file and can be updated by changing the hex values:

```css
/* Example: Change active workspace color */
#workspaces button.active {
    background: linear-gradient(135deg, #your-color, #your-secondary-color);
}
```

### Adding Modules
New modules can be added to the configuration by:
1. Adding the module name to the appropriate `modules-*` array
2. Defining module configuration in the settings
3. Adding corresponding CSS styling

### Layout Adjustments
- **Position**: Change `position` from "top" to "bottom"
- **Height**: Adjust the `height` value
- **Margins**: Modify `margin-*` values for spacing
- **Module Order**: Reorder items in the `modules-*` arrays

## Animations and Effects

The configuration includes several animations:
- **Workspace Transitions**: Smooth scaling and color changes
- **Critical States**: Blinking animations for battery/temperature warnings
- **Hover Effects**: Subtle transform and shadow effects
- **Submap Pulse**: Breathing animation for active keybind modes

## Troubleshooting

### Common Issues
1. **Missing Icons**: Ensure Font Awesome is installed and available
2. **Temperature Module**: May need to adjust `hwmon-path` for your system
3. **Network Issues**: Verify NetworkManager is running
4. **Audio Problems**: Check PulseAudio/PipeWire status

### Debug Mode
Enable debug output by adding to waybar execution:
```bash
waybar --log-level debug
```

### Reloading Configuration
Waybar automatically reloads on configuration changes, or manually:
```bash
pkill -SIGUSR2 waybar
```

## Integration Notes

This waybar configuration is specifically designed for:
- **NixOS** systems using Home Manager
- **Hyprland** as the window manager  
- **Stylix** for system-wide theming
- **Catppuccin Mocha** color scheme

The module integrates with the systemd user session and will automatically start/restart with Hyprland sessions.