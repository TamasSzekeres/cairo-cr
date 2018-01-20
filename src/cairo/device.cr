require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PDeviceT
  class Device
    def initialize(device : LibCairo::PDeviceT)
      raise ArgumentError.new("'device' cannot be null.") if device.null?
      @device = device
    end

    def finalize
      LibCairo.device_destroy(@device)
    end

    def reference : Device
      Device.new(LibCairo.device_reference(@device))
    end

    def type : DeviceType
      DeviceType.new(LibCairo.device_get_type(@device).value)
    end

    def status : Status
      Status.new(LibCairo.device_status(@device).value)
    end

    def acquire : Status
      Status.new(LibCairo.device_acquire(@device).value)
    end

    def release
      LibCairo.device_release(@device)
      self
    end

    def flush
      LibCairo.device_flush(@device)
      self
    end

    def finish
      LibCairo.device_finish(@device)
      self
    end

    def reference_count : UInt32
      LibCairo.device_get_reference_count(@device)
    end

    def user_data(key : UserDataKey) : Void*
      LibCairo.device_get_user_data(@device, key.to_unsafe)
    end

    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      Status.new(LibCairo.device_set_user_data(@device, key.to_unsafe, user_data, destroy).value)
    end

    def observer_print(write_func : LibCairo::WriteFuncT, closure : Void*) : Status
      Status.new(LibCairo.device_observer_print(@device, write_func, closure).value)
    end

    def observer_elapsed : Float64
      LibCairo.device_observer_elapsed(@device)
    end

    def observer_paint_elapsed : Float64
      LibCairo.device_observer_paint_elapsed(@device)
    end

    def observer_mask_elapsed : Float64
      LibCairo.device_observer_mask_elapsed(@device)
    end

    def observer_fill_elapsed : Float64
      LibCairo.device_observer_fill_elapsed(@device)
    end

    def observer_stroke_elapsed : Float64
      LibCairo.device_observer_stroke_elapsed(@device)
    end

    def observer_glyphs_elapsed : Float64
      LibCairo.device_observer_glyphs_elapsed(@device)
    end

    def to_unsafe : LibCairo::PDeviceT
      @device
    end
  end
end
