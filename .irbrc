require 'irb/ext/save-history'

IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"
IRB.conf[:SAVE_HISTORY] = 100
