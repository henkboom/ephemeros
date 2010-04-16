require 'dokidoki.module' [[]]

local kernel = require 'dokidoki.kernel'

local race = require 'race'

--kernel.set_fullscreen(true)
kernel.set_video_mode(1024, 768)
kernel.start_main_loop(race.make())
