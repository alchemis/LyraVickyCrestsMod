class PokeBattle_Move
  attr_accessor :submoves
  attr_accessor :parentmove
  attr_accessor :maxpp
  alias_method :fmss_initialize, :initialize if !method_defined?(:fmss_initialize)
  def initialize(battle, move, user, zbase = nil, fmss_parentmove: nil)
     ret = fmss_initialize(battle, move, user, zbase = nil)
     if @data && @data.submoves
        @submoves = []
        for sb_move in @data.submoves
          new_move = PokeBattle_Move.pbFromPBMove(battle,PBMove.new(sb_move),user,zbase)
          new_move.parentmove = self
          new_move.pp = @pp
          @submoves.push(new_move)
        end
     end
     return ret
  end
  def multimove?
    return false if !@submoves
    return true if @submoves.length > 0
    return false
  end
end

class PokeBattle_Battler
  alias_method :fmss_pbReducePP, :pbReducePP if !method_defined?(:fmss_pbReducePP)
  def pbReducePP(move, pressure = false)
    if move.parentmove
      fmss_pbReducePP(move.parentmove,pressure)
      for sb_move in move.parentmove.submoves
          fmss_pbReducePP(sb_move,pressure)
      end
    else return fmss_pbReducePP(move, pressure = pressure)
    end

  end
end
class MoveData
    attr_reader :submoves
    alias_method :fmss_initialize, :initialize if !method_defined?(:fmss_initialize)
    def initialize(movesym, data)
      ret = fmss_initialize(movesym, data)
      @submoves = @flags[:submoves] if @flags[:submoves]
      return ret
    end
end

class PokeBattle_Battle
  alias_method :fmss_pbRegisterMove, :pbRegisterMove if !method_defined?(:fmss_pbRegisterMove)
  def pbRegisterMove(idxPokemon, idxMove, showMessage: false)
    if idxMove.is_a?(Array)
      return false if idxMove.nil?
      thispkmn = @battlers[idxPokemon]
      side = pbIsOpposing?(idxPokemon) ? 1 : 0
      owner = pbGetOwnerIndex(idxPokemon)
      basemove = thispkmn.moves[idxMove[0]].submoves[idxMove[1]]
      thispkmn.selectedMove = basemove.move
      return false if !pbCanChooseMove?(idxPokemon, basemove, showMessage: showMessage)

      @choices[idxPokemon] = [:move, idxMove[0], basemove, -1]
      return true
    else return fmss_pbRegisterMove(idxPokemon, idxMove, showMessage: showMessage)
    end
  end

  def pbCanShowFightMenu?(idxPokemon)
    battler = pkmn = @battlers[idxPokemon]
    return false if !pbCanShowCommands?(idxPokemon)
    return false if fmss_get_all_moves_with_submoves(battler).none? { |i| pbCanChooseMove?(idxPokemon, i) }
    return true
  end

  def fmss_search_move(pkmn,move)
    for _move in pkmn.moves
        return _move if _move.move == move 
        if _move.multimove?
          for _submove in _move.submoves
            return _submove if _submove.move == move
          end
        end
    end
    return false
  end

  def fmss_get_all_moves_with_submoves(pkmn)
    ret = []
    for move in pkmn.moves
        if move.multimove?
          for submove in move.submoves
              ret.push(submove)
          end
        else ret.push(move)
        end
    end
    return ret
  end
end

#move index qol
class PokeBattle_Scene
  alias_method :fmss_pbStartBattle, :pbStartBattle if !method_defined?(:fmss_pbStartBattle)
    def pbStartBattle(battle)
      @lastsubmove = [0, 0, 0, 0]
      return fmss_pbStartBattle(battle)
    end
end



#choice lock handling
CodeInjector.replace_in_method(:PokeBattle_Battle,:pbCanChooseMove?, "if pkmn.moves.none? { |moveloop| moveloop.move == pkmn.effects[:ChoiceBand] }",
"
  if !fmss_search_move(pkmn,pkmn.effects[:ChoiceBand])
"
)

CodeInjector.replace_in_method(:PokeBattle_Battle,:pbCanChooseMove?, "pkmn.moves.any? { |moveloop| moveloop.move == pkmn.effects[:ChoiceBand] } &&",
"
  fmss_search_move(pkmn,pkmn.effects[:ChoiceBand]) &&
"
)

CodeInjector.replace_in_method(:PokeBattle_Battle,:pbCanChooseMove?, "if pkmn.moves.none? { |moveloop| moveloop.move == pkmn.effects[:GorillaLock] }",
"
  if !fmss_search_move(pkmn,pkmn.effects[:GorillaLock])
"
)

CodeInjector.replace_in_method(:PokeBattle_Battle,:pbCanChooseMove?, "pkmn.moves.any? { |moveloop| moveloop.move == pkmn.effects[:GorillaLock] } &&",
"
  fmss_search_move(pkmn,pkmn.effects[:GorillaLock]) &&
"
)

#battle msg
CodeInjector.replace_in_method(:PokeBattle_Move,:pbDisplayUseMessage, '@battle.pbDisplayBrief(_INTL("{1} used\n{2}!", attacker.pbThis, movename))',
'
if @parentmove
  @battle.pbDisplayBrief(_INTL("{1}\'s {2}\nlet it use {3}!", attacker.pbThis,@parentmove.name, movename))
else
  @battle.pbDisplayBrief(_INTL("{1} used\n{2}!", attacker.pbThis, movename))
end
'
)

#rejuv specific hook
CodeInjector.replace_in_method(:PokeBattle_Scene,:pbFightMenu, "@battle.specialchoices[index] = [nil] if v < 0",
"
@battle.specialchoices[index] = [nil] if !v.is_a?(Array) && v < 0
"
)

#menu stuff
CodeInjector.insert_in_method(:PokeBattle_Scene,:__rejuv_pbFightMenu, "elsif Input.trigger?(Input::C)",
 "if battler.moves[cw.index].multimove? && !@fmss_choosing_submove_index
      @fmss_choosing_submove_index = cw.index
      @fmss_old_moves = battler.moves
      battler.moves = battler.moves[cw.index].submoves
      lastIndex = @lastsubmove[index]
      if battler.moves[lastIndex]
        cw.setIndex(lastIndex)
      else
        cw.setIndex(0)
      end
      update_menu = true
      next
  end
  if defined?(@fmss_choosing_submove_index) && @fmss_choosing_submove_index
    ret = [@fmss_choosing_submove_index,cw.index]
    battler.moves = @fmss_old_moves
    @fmss_old_moves = nil
    @lastmove[index] = @fmss_choosing_submove_index
    @lastsubmove[index] = cw.index
    @fmss_choosing_submove_index = nil
    return ret
  end
 
 "
)

CodeInjector.insert_in_method(:PokeBattle_Scene,:__rejuv_pbFightMenu, "elsif Input.trigger?(Input::B)",
"
  if defined?(@fmss_choosing_submove_index) && @fmss_choosing_submove_index
    cw.setIndex(@fmss_choosing_submove_index)
    @fmss_choosing_submove_index = nil
    battler.moves = @fmss_old_moves
    @fmss_old_moves = nil
    update_menu = true
    next
  end
"
)

CodeInjector.replace_in_method(:PokeBattle_Battle,:commandloop, "basemove = @zMove[0][owner] == i ? @battlers[i].zmoves[index] : @battlers[i].moves[index]",
"
if index.is_a?(Array)
  basemove = @zMove[0][owner] == i ? @battlers[i].zmoves[index[0]] : @battlers[i].moves[index[0]].submoves[index[1]]
else
  basemove = @zMove[0][owner] == i ? @battlers[i].zmoves[index] : @battlers[i].moves[index]
end
"
)

CodeInjector.replace_in_method(:PokeBattle_Battle,:commandloop, "if index < 0",
"
if !index.is_a?(Array) && index < 0
"
)

ModCacheInjection.hook(:moves) {
  $cache.moves[:MULTIMOVETEST] = MoveData.new(:MULTIMOVETEST,{
    :name => "Normal Mastery",
    :desc => "Test.",
    :function => 0x000,
    :type => :NORMAL,
    :category => :status,
    :basedamage => 0,
    :accuracy => 100,
    :maxpp => 5,
    :target => :SingleNonUser,
    :submoves => [:DOUBLEHIT,:TAILWHIP,:QUICKATTACK,:GROWL]
  })

}