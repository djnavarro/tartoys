
library(targets)
library(crew)

tar_option_set(controller = crew_controller_local(workers = 3))

sleeper <- function(duration, pipeline_start) {
  sleep_start <- Sys.time()
  Sys.sleep(duration)
  sleep_stop <- Sys.time()
  data.frame(
    start = round(difftime(sleep_start, pipeline_start), digits = 3),
    stop  = round(difftime(sleep_stop, pipeline_start), digits = 3)
  )
}

list(
  tar_target(start, Sys.time(), cue = tar_cue("always")),
  tar_target(wait1, sleeper(1, start)),
  tar_target(wait2, sleeper(2, start)),
  tar_target(wait3, sleeper(3, start)),
  tar_target(wait4, sleeper(4, start)),
  tar_target(waits, rbind(wait1, wait2, wait3, wait4))
)
