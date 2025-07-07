# linux-setup
Automate Linux Config

## TMUX - Setup
Features:
* Autostart tmux session on terminal open
* Clean UI, status bar
* Plugin setup:
  - tmux-resurrect → Save/restore panes & sessions manually
  - tmux-continuum → Auto-save every 15 mins, auto-restore on startup
  - Mouse support, Vim-style copy mode

⸻

Download
```
mkdir tmux
cd tmux
wget -c https://github.com/permadihendra/linux-setup/blob/aa3cc6e5fce0ce1fe868666f8bf6b4884bc529f3/setup_tmux_config.sh 
```

🚀 Run it:

```
chmod +x setup_tmux_config.sh
./setup_tmux_config.sh
```

**Notes
If not working, try to manually copy-paste it using nano or linux terminal editor**

Then open a new terminal and inside tmux, press:

Ctrl-b + Shift-I

Let me know if you want:
	•	tmux battery/load/network widgets
	•	tmux integration with Python/conda env
	•	pane/session switching with fzf

 
