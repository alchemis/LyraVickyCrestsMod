class Module

  alias alias_method2 alias_method unless method_defined?(:alias_method2)
  ALIASED_METHODS = {}
  ALIAS_RMAP = {}
  ALIAS_OMAP = {}

  def alias_method(new, old)
    classname = self.inspect[":"] ? self.inspect[/:([a-zA-Z0-9]+)/, 1] : self.inspect.strip
    original = ALIASED_METHODS[[classname, old]] || old
    ALIAS_RMAP[[classname, original]] ||= new
    ALIASED_METHODS[[classname, new]] = original
    self.send(:alias_method2, new, old)
  end

end

module CodeInjector

  $injector_global_priority = 1000
  $code_injector_cache_enabled = true
  $code_injector_logging_enabled = true

  <<-DOC
  >> useful functions and event hooks for cross-compatibility and simplicity. embedded in the standard api.
  DOC

  <<-DOC
  COMMON
  @param function - a symbol (i.e. :function) corresponding to a function bound to Object. this includes all global functions.
  @param clazz - a class containing the target method
  @param method - a symbol (i.e. :method) corresponding to a method bound to @clazz. this includes all global functions.
  @param target - a string, or one of :HEAD or :TAIL. insertion will be after the first match, or after the definition with :HEAD and right 
                  before the last "end" with :TAIL
  @param proc - either a Proc object or a string.
  @param index - if nonzero, attempts to match a duplicate corresponding to the index (for example with multiple "ends")
  >> for injection, replacement, and deletion functions.
  DOC

  <<-DOC
  >> injects a block of code after the specified target in the target function.
  DOC
  def self.insert_in_function(function, target, proc, index=0, priority=$injector_global_priority)
    return if self.has_valid_cache
    self.insert_in_method(:Object, function, target, proc, index, priority)
  end

  <<-DOC
  >> injects a block of code after the specified target in the target method.
  DOC
  def self.insert_in_method(clazz, method, target, proc, index=0, priority=$injector_global_priority)
    return if self.has_valid_cache
    PENDING_INSERTIONS.push([clazz, method, target, proc, index, false, priority])
  end

  <<-DOC
  >> injects a block of code before the specified target in the target function.
  DOC
  def self.insert_in_function_before(function, target, proc, index=0, priority=$injector_global_priority)
    return if self.has_valid_cache
    self.insert_in_method_before(:Object, function, target, proc, index, priority)
  end

  <<-DOC
  >> injects a block of code before the specified target in the target method.
  DOC
  def self.insert_in_method_before(clazz, method, target, proc, index=0, priority=$injector_global_priority)
    return if self.has_valid_cache
    PENDING_INSERTIONS.push([clazz, method, target, proc, index, true, priority])
  end

  <<-DOC
  >> replaces a target line in the target function. chains with other operations.
  DOC
  def self.replace_in_function(function, target, proc, index=0, priority=$injector_global_priority)
    return if self.has_valid_cache
    self.replace_in_method(:Object, function, target, proc, index, priority)
  end

  <<-DOC
  >> replaces a target line in the target method. chains with other operations.
  DOC
  def self.replace_in_method(clazz, method, target, proc, index=0, priority=$injector_global_priority)
    return if self.has_valid_cache
    PENDING_PRE_INSERTIONS.push([clazz, method, target, proc, index, false, priority])
    self.delete_in_method(clazz, method, target, index, priority)
  end

  <<-DOC
  >> deletes a target line in the target function. chains with other operations.
  DOC
  def self.delete_in_function(function, target, index=0, priority=$injector_global_priority)
    return if self.has_valid_cache
    self.delete_in_method(:Object, function, target, index, priority)
  end

  <<-DOC
  >> deletes a target line in the target method. chains with other operations.
  DOC
  def self.delete_in_method(clazz, method, target, index=0, priority=$injector_global_priority)
    return if self.has_valid_cache
    PENDING_DELETIONS.push([clazz, method, target, index, priority])
  end

  <<-DOC
  @param load_event - a symbolic function reference (i.e. :function)
  @param priority - a numeric priority
  >> useful for deserializing data. 
  DOC
  def self.add_init_event(load_event, priority=$injector_global_priority)
    EVENT_ON_INIT.push([load_event, priority]) unless EVENT_ON_LOAD.include?([load_event, priority])
  end

  <<-DOC
  @param load_screen_event - a symbolic function reference (i.e. :function)
  @param priority - a numeric priority
  >> these events are called as the load screen is being entered.
  DOC
  def self.add_load_screen_event(load_screen_event, priority=$injector_global_priority)
    EVENT_ON_LOAD_SCREEN.push([load_screen_event, priority]) unless EVENT_ON_LOAD.include?([load_screen_event, priority])
  end

  <<-DOC
  @param load_event - a symbolic function reference (i.e. :function)
  @param priority - a numeric priority
  >> these events are called as the save is being loaded, so interacting with cache is not safe. useful for deserializing data. numerically 
     higher priorities go first.
  DOC
  def self.add_load_event(load_event, priority=$injector_global_priority)
    EVENT_ON_LOAD.push([load_event, priority]) unless EVENT_ON_LOAD.include?([load_event, priority])
  end

  <<-DOC
  @param play_event - a symbolic function reference (i.e. :function)
  @param priority - a numeric priority
  >> these events are called when a save is fully loaded. useful for deserializing data. numerically higher priorities go first.
  DOC
  def self.add_play_event(play_event, priority=$injector_global_priority)
    EVENT_ON_PLAY.push([play_event, priority]) unless EVENT_ON_PLAY.include?([play_event, priority])
  end

  <<-DOC
  @param new_file_event - a symbolic function reference (i.e. :function)
  @param priority - a numeric priority
  >> these events are called when the player creates a new save file. numerically higher priorities go first.
  DOC
  def self.add_new_file_event(new_file_event, priority=$injector_global_priority)
    EVENT_ON_NEW_FILE.push([new_file_event, priority]) unless EVENT_ON_NEW_FILE.include?([new_file_event, priority])
  end

  <<-DOC
  @param save_event - a symbolic function reference (i.e. :function)
  @param priority - a numeric priority
  >> these events are called on save. useful for serializing data. numerically higher priorities go first.
  DOC
  def self.add_save_event(save_event, priority=$injector_global_priority)
    EVENT_ON_SAVE.push([save_event, priority]) unless EVENT_ON_SAVE.include?([save_event, priority])
  end

  <<-DOC
  >> sets the global default priority for injectors
  DOC
  def self.set_global_priority(priority=1000)
    $injector_global_priority = priority
  end

  <<-DOC
  >> executes a block of code with the given priority before reverting to the default.
  DOC
  def self.with_priority(priority)
    self.set_global_priority(priority)
    yield
    self.set_global_priority
  end

  <<-DOC
  >> toggles the injection cache, primarily for debuggers
  DOC
  def self.toggle_cache(toggle=false)
    $code_injector_cache_enabled = toggle
  end

  private

  INJECTOR_LOG_PATH = File.dirname(__FILE__) + "/../CodeInjectorLog/"

  <<-DOC
  dumps to dev.out
  DOC
  def self.log(*args)
    return unless $code_injector_logging_enabled
    Dir.mkdir(INJECTOR_LOG_PATH) unless Dir.exist?(INJECTOR_LOG_PATH)
    str_final = ""
    ##LYRA
    args.each {|msg| puts "CodeInjector: #{msg}"}
    ##/LYRA
    args.each {|msg| str_final += msg.to_s + (msg == args[-1] ? "" : " ") }
    File.open(INJECTOR_LOG_PATH + "dev.out", "a+") { |f| f.write("#{str_final}\n") }
  end

  SUB_2 = "../../"
  MOD_DIR = "#{File.dirname(__FILE__)}/#{SUB_2}"
  CODE_INJECTOR_ENTRYPOINT = PokemonLoad.instance_method(:pbStartLoadScreen) ##LYRA: changed it to load on start screen

  def self.get_or_create_method_attr(clazz, method, sym, default)
    METHOD_MODS[clazz][method][sym] = default if METHOD_MODS[clazz][method][sym].nil?
    METHOD_MODS[clazz][method][sym]
  end

  def self.get_or_create_method(clazz, method, base)
    METHOD_MODS[clazz] = {} if METHOD_MODS[clazz].nil?
    METHOD_MODS[clazz][method] = {} if METHOD_MODS[clazz][method].nil?
    METHOD_MODS[clazz][method][:CODE] = base.each_with_index.map { |line, num| [num, line] }.to_h if METHOD_MODS[clazz][method][:CODE].nil?
  end

  def self.delete_in_method_internal(clazz, method, target, index, origin = method)
    clazz = Kernel.const_get(clazz) if clazz.is_a? Symbol
    method = Module::ALIAS_RMAP[[clazz.name, method]] if Module::ALIAS_RMAP[[clazz.name, method]]
    base = (METHOD_MODS[clazz].nil? or METHOD_MODS[clazz][method].nil? or METHOD_MODS[clazz][method][:CODE].nil?) ? get_method_source(clazz, method) : METHOD_MODS[clazz][method][:CODE].values
    deletion_index = get_target_index(base, target, index)
    if deletion_index.nil?
      CodeInjector.log("Couldn't find target \"#{target}\" (index #{index}) in method \"#{origin}\" of class \"#{clazz}\"")
      return false
    end
    get_or_create_method(clazz, method, base)
    get_or_create_method_attr(clazz, method, :DELETE, {})[deletion_index] = true unless deletion_index.nil?
    !deletion_index.nil?
  end

  def self.insert_in_method_internal(clazz, method, target, proc, index, prepend, origin = method)
    clazz = Kernel.const_get(clazz) if clazz.is_a? Symbol
    method = Module::ALIAS_RMAP[[clazz.name, method]] if Module::ALIAS_RMAP[[clazz.name, method]]
    base = (METHOD_MODS[clazz].nil? or METHOD_MODS[clazz][method].nil? or METHOD_MODS[clazz][method][:CODE].nil?) ? get_method_source(clazz, method) : METHOD_MODS[clazz][method][:CODE].values
    inserted = proc.class == String ? [""] + proc.split("\n") + [""] : get_method_source(nil, proc)
    insertion_index = get_target_index(base, target, index)
    if insertion_index.nil?
      CodeInjector.log("Couldn't find target \"#{target}\" (index #{index}) in method \"#{origin}\" of class \"#{clazz}\"")
      return false
    end
    insertion_index -= 1 if prepend
    get_or_create_method(clazz, method, base)
    injected = get_or_create_method_attr(clazz, method, :INJECT, {})
    injected[insertion_index] = [] if injected[insertion_index].nil?
    injected[insertion_index] += inserted[(1...inserted.length - 1)]
    return false if insertion_index.nil?
    true
  rescue NoMethodError
    CodeInjector.log("Failed to insert in method", method, "of class", clazz, "at target \"", target, "\" with index", index)
  end

  def self.get_target_index(base, target, index)
    insertion_index = nil
    insertion_index = -1 if target == :HEAD
    insertion_index = -2 if target == :TAIL
    if insertion_index.nil?
      base.each_with_index do |line, i|
        if line.strip == target.strip
          return i if index == 0
          index -= 1
        end
      end
    end
    insertion_index
  end

  def self.get_method_source(clazz, method)
    if method.is_a? Proc
      temp, line = method.source_location
    else
      clazz = Kernel.const_get(clazz) if clazz.is_a? Symbol
      temp, line = clazz.instance_method(method).source_location rescue clazz.method(method).source_location
    end
    file = temp
    # lazy
    file = "#{MOD_DIR}#{temp}.rb" unless File.exists?(file) and !File.directory?(file)
    file = "#{MOD_DIR}#{SUB_2}Scripts/Rejuv/#{temp}.rb" unless File.exists?(file) and !File.directory?(file)
    file = "#{MOD_DIR}#{SUB_2}Scripts/#{temp}.rb" unless File.exists?(file) and !File.directory?(file)
    if File.exists?(file)
      lines, code, code_lines, valid = IO.foreach(file).to_a, "", [], false
      (line - 1..lines.length).each do |index|
        current = lines[index].strip
        next if current.start_with?("#")
        if current.include?("#")
          tmp = current.split(/#(?=([^"\\]*(\\.|"([^"\\]*\\.)*[^"\\]*"))*[^"]*$)/)
          current = tmp[0] if tmp.length > 0
        end
        next if current.empty? or current.length == 0
        current.split(/;/).each do |str|
          code += str + "\n"
          code_lines.push(str)
          valid = valid_expression(code) if str.include?("end")
          break if valid
        end
        break if valid
      end
      code_lines[0] = "def #{method}#{code_lines[0].match(/\(.*\)/)}\n" if valid unless method.is_a? Proc
      return valid ? code_lines : nil
    end
  rescue Exception
    nil
  end

  def self.valid_expression(str)
    catch(:valid) { eval("BEGIN{throw :valid}\n#{str}") }
    str !~ /[,\\]\s*\z/
  rescue Exception
    false
  ensure
    true
  end

  def self.has_valid_cache
    $code_injector_cache_enabled and $code_injector_aggressive_cache
  end

  LOADED_FILES = {} unless defined? LOADED_FILES
  PENDING_DELETIONS = []
  PENDING_PRE_INSERTIONS = []
  PENDING_INSERTIONS = []
  METHOD_MODS = {} if !defined? METHOD_MODS
  NO_OP = {}
  EVENT_ON_INIT = []
  EVENT_ON_LOAD_SCREEN = []
  EVENT_ON_LOAD = []
  EVENT_ON_PLAY = []
  EVENT_ON_SAVE = []
  EVENT_ON_NEW_FILE = []
  $code_injector_source = ""

  def self.process_injections
    CodeInjector::LOADED_FILES.clear
    if CodeInjector.has_valid_cache
      t = Time.now
      $code_injector_aggressive_cache.each { |clazz, source| clazz.class_eval(source) }
      CodeInjector.log("aggressive insertion cache compile time:", Time.now - t)
    else
      $code_injector_aggressive_cache = $code_injector_cache_enabled ? {} : nil
      CodeInjector::EVENT_ON_PLAY.sort! { |a, b| b[1] <=> a[1]}
      CodeInjector::EVENT_ON_SAVE.sort! { |a, b| b[1] <=> a[1]}
      insertions = Time.now
      CodeInjector::PENDING_PRE_INSERTIONS.sort! { |a, b| b[6] <=> a[6]}
      CodeInjector::PENDING_PRE_INSERTIONS.each { |pending| CodeInjector.insert_in_method_internal(pending[0], pending[1], pending[2], pending[3], pending[4], pending[5]) }
      CodeInjector::PENDING_INSERTIONS.sort! { |a, b| b[6] <=> a[6]}
      CodeInjector::PENDING_INSERTIONS.each { |pending| CodeInjector.insert_in_method_internal(pending[0], pending[1], pending[2], pending[3], pending[4], pending[5]) }
      deletions = Time.now
      CodeInjector::PENDING_DELETIONS.sort! { |a, b| b[4] <=> a[4]}
      CodeInjector::PENDING_DELETIONS.each { |pending| CodeInjector.delete_in_method_internal(pending[0], pending[1], pending[2], pending[3]) }
      method_mods = Time.now
      CodeInjector::METHOD_MODS.each do |clazz, methods|
        $code_injector_source = ""
        methods.each do |m, ref|
          ref[:CODE].each do |num, line|
            $code_injector_source += line + "\n" unless ref[:DELETE] and ref[:DELETE][num]
            unless ref[:INJECT].nil?
              ref[:INJECT][-1].each { |injected| $code_injector_source += injected + "\n" } if num == 0 unless ref[:INJECT][-1].nil?
              ref[:INJECT][num].each { |injected| $code_injector_source += injected + "\n" } unless ref[:INJECT][num].nil?
              ref[:INJECT][-2].each { |injected| $code_injector_source += injected + "\n" } if num == ref[:CODE].length - 2 unless ref[:INJECT][-2].nil?
            end
          end
          ref[:INJECT].clear if ref[:INJECT]
          ref[:DELETE].clear if ref[:DELETE]
        end
        clazz.class_eval($code_injector_source)
        methods.delete_if { |method| method.is_a? Proc}
        $code_injector_aggressive_cache[clazz] = $code_injector_source if $code_injector_cache_enabled
      end
      end_compile = Time.now
      CodeInjector.log("staging insertions=#{deletions - insertions}", "staging deletions=#{method_mods - deletions}", "compilation=#{end_compile - method_mods}")
    end

  end

end

# ======================================================================================================================================== #
# ================================================================ PATCH ================================================================= #
# ======================================================================================================================================== #

##LYRA
class PokemonLoad

  def pbStartLoadScreen
    CodeInjector.process_injections
    CodeInjector::CODE_INJECTOR_ENTRYPOINT.bind(self).()
  end
##/LYRA changed it to inject in load screen.
end