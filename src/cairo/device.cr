require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Devices are the abstraction Cairo employs for the rendering system used by a `Surface`.
  # You can get the device of a surface using `Surface#device`.
  #
  # Devices are created using custom functions specific to the rendering system you want to use.
  # See the documentation for the surface types for those functions.
  #
  # An important function that devices fulfill is sharing access to the rendering system between
  # Cairo and your application. If you want to access a device directly that you used to draw to with Cairo,
  # you must first call `Device#flush` to ensure that Cairo finishes all operations on the device and resets it to a clean state.
  #
  # Cairo also provides the functions `Device#acquire` and `Device#release` to synchronize access to the
  # rendering system in a multithreaded environment. This is done internally, but can also be used by applications.
  #
  #
  # A `Device` represents the driver interface for drawing operations to a `Surface`.
  # There are different subtypes of `Device` for different drawing backends.
  #
  # The type of a device can be queried with `Device#type`.
  #
  # Memory management of `Device` is done with `Device#reference` and `Device#finalize`.
  class Device
    def initialize(device : LibCairo::PDeviceT)
      raise ArgumentError.new("'device' cannot be null.") if device.null?
      @device = device
    end

    # Decreases the reference count on device by one. If the result is zero,
    # then device and all associated resources are freed. See `Device#reference`.
    #
    # This function may acquire devices if the last reference was dropped.
    def finalize
      LibCairo.device_destroy(@device)
    end

    # Increases the reference count on device by one. This prevents device from being destroyed until
    # a matching call to `Device#finalize` is made.
    #
    # Use `Device#reference_count` to get the number of references to a `Device`.
    #
    # ###Returns
    # The referenced `Device`.
    def reference : Device
      Device.new(LibCairo.device_reference(@device))
    end

    # This function returns the type of the device. See `DeviceType` for available types.
    #
    # ###Returns
    # The type of device.
    def type : DeviceType
      DeviceType.new(LibCairo.device_get_type(@device).value)
    end

    # Checks whether an error has previously occurred for this device.
    #
    # ###Returns
    # `Status#Success` on success or an error code if the device is in an error state.
    def status : Status
      Status.new(LibCairo.device_status(@device).value)
    end

    # Acquires the device for the current thread. This function will block until no other thread has acquired the device.
    #
    # If the return value is `Status::Success`, you successfully acquired the device.
    # From now on your thread owns the device and no other thread will be able to acquire it until
    # a matching call to `Device#release`. It is allowed to recursively acquire the device multiple times from the same thread.
    #
    # You must never acquire two different devices at the same time unless this is explicitly allowed.
    # Otherwise the possibility of deadlocks exist. As various Cairo functions can acquire devices when called,
    # these functions may also cause deadlocks when you call them with an acquired device. So you must not have
    # a device acquired when calling them. These functions are marked in the documentation.
    #
    # ###Returns
    # `Status::Success` on success or an error code if the device is in an error state and could not be acquired.
    # After a successful call to `Device#acquire`, a matching call to `Device#release` is required.
    def acquire : Status
      Status.new(LibCairo.device_acquire(@device).value)
    end

    # Releases a device previously acquired using `Device#acquire`. See that function for details.
    def release
      LibCairo.device_release(@device)
      self
    end

    # Finish any pending operations for the device and also restore any temporary modifications
    # cairo has made to the device's state. This function must be called before switching from
    # using the device with Cairo to operating on it directly with native APIs.
    # If the device doesn't support direct access, then this function does nothing.
    #
    # This function may acquire devices.
    def flush
      LibCairo.device_flush(@device)
      self
    end

    # This function finishes the device and drops all references to external resources.
    # All surfaces, fonts and other objects created for this device will be finished, too.
    # Further operations on the device will not affect the device but will instead trigger a `Status::DeviceFinished` error.
    #
    # When the last call to `Device#finalize` decreases the reference count to zero,
    # cairo will call `Device#finish` if it hasn't been called already, before freeing the resources associated with the device.
    #
    # This function may acquire devices.
    def finish
      LibCairo.device_finish(@device)
      self
    end

    # Returns the current reference count of device.
    #
    # ###Returns
    # The current reference count of device. If the object is a `nil` object, 0 will be returned.
    def reference_count : UInt32
      LibCairo.device_get_reference_count(@device)
    end

    # Return user data previously attached to device using the specified key.
    # If no user data has been attached with the given key this function returns `Nil`.
    #
    # ###Parameters
    # - **key** the address of the UserDataKey the user data was attached to
    #
    # ###Returns
    # The user data previously attached or `Nil`.
    def user_data(key : UserDataKey) : Void*
      LibCairo.device_get_user_data(@device, key.to_unsafe)
    end

    # Attach user data to device. To remove user data from a surface, call this function with
    # the key that was used to set it and `Nil` for data.
    #
    # ###Parameters
    # - **key** the address of a `UserDataKey` to attach the user data to
    # - **user_data**
    # - **the** user data to attach to the `Device`
    # - **destroy** a `LibCairo::DestroyFuncT` which will be called when the `Context` is destroyed
    # or when new user data is attached using the same key.
    #
    # ###Returns
    # `Status::Success` or `Status::NoMemory` if a slot could not be allocated for the user data.
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
