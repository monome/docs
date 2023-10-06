function quickclock(fn, div)
  return clock.run(function() while true do clock.sync(div) fn() end end)
end

function clock.transport.start()
  print("started", clock.get_beats())
  test_clock = clock.run(
    function()
      while true do
        clock.sync(1/4)
        print('step', clock.get_beats())
      end
    end
  )
  print(test_clock)
end

function clock.transport.stop()
  print("stopped")
  clock.cancel(test_clock)
  test_clock = nil -- cleans up the variable
end
