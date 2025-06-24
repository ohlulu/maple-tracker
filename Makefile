global: open

.PHONY: open
open:
	pkill -x Xcode 2>/dev/null || true
	xed ./MapleTracker