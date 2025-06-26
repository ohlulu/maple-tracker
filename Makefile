global: open

.PHONY: open
open:
	pkill -x Xcode 2>/dev/null || true
	sleep 0.3
	xed ./MapleTracker