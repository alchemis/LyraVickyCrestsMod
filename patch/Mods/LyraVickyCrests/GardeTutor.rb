if !(File.exist?('patch/Init/0000.cache_injection.rb') or !File.exist?('patch/Init/0000.map_injection.rb')) then 
  print("Error, patching libraries not found. Please download 0000.cache_injection.rb and 0000.map_injection.rb from wiresegal's modpack at: github.com/yrsegal/rejuvenation-modpack")
end

Gardetutor_moves = [:LOVELYKISS,:FIRELASH,:OUTRAGE,:PSYCHOCUT,:SPIRITBREAK,:NASTYPLOT]

class GardeTutor_MoveRelearnerScene < MoveRelearnerScene

  def initialize()
    @moves = Gardetutor_moves
  end

  def initializePage(pokemon, page)
    @pokemon = pokemon
    @partyid = @party.index(pokemon)
    @page = page
    @error = nil

    pbDrawBackground()
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["msgwindow"] = Window_AdvancedTextPokemon.new("")
    @sprites["msgwindow"].visible = false
    @sprites["msgwindow"].viewport = @viewport
    @sprites["leftarrow"] = AnimatedSprite.new("Graphics/Pictures/leftarrow", 8, 40, 28, 2, @viewport)
    @sprites["rightarrow"] = AnimatedSprite.new("Graphics/Pictures/rightarrow", 8, 40, 28, 2, @viewport)
    @sprites["leftarrow"].y = ARROW_POS_X[0]
    @sprites["rightarrow"].x = ARROW_POS_X[1]
    @sprites["rightarrow"].y = ARROW_POS_Y
    @sprites["leftarrow"].y = ARROW_POS_Y
    @sprites["leftarrow"].play
    @sprites["rightarrow"].play

    @label = "Special Moves"

    if @moves == [] && @error.nil?
      @error = _INTL("No moves available.")
    end

    applySorting

    tts("#{pokemon.name}'s #{@label}") unless @relearner

    @sprites["pokeicon"].dispose if @sprites["pokeicon"]
    @sprites["pokeicon"] = PokemonIconSprite.new(@pokemon, @viewport)
    @sprites["pokeicon"].x = SPRITESM_OFFSET[0]
    @sprites["pokeicon"].y = SPRITESM_OFFSET[1]

    moveCommands = @moves.map { |i| pbGetDisplayMoveName(i) }
    @sprites["commands"] = Window_CommandPokemon.new(moveCommands, 32)
    @sprites["commands"].x = Graphics.width
    @sprites["commands"].height = 32 * (VISIBLEMOVES + 1)
    pbDrawMoveList
  end
end

class GardeTutor_MoveTutorScreen
  def initialize(scene)
    @scene = scene
    @moves = Gardetutor_moves
  end

  def pbStartScreen(pokemon)
    @scene.pbStartScene($Trainer.party, $Trainer.party.index(pokemon), true)
    loop do
      pokemon, move = @scene.pbChooseMove
      if !move.is_a?(Symbol)
        # Learning from party menu doesn't require a confirmation to exit.
        if Kernel.pbConfirmMessage(_INTL("Give up trying to teach a new move to {1}?", pokemon.name))
          @scene.pbEndScene
          return false
        end
      elsif Kernel.pbConfirmMessage(_INTL("Teach {1}?", getMoveName(move)))
        if pbTryLearnMove(pokemon, move, dontrestorePP: false)
          @scene.pbEndScene
          return true
        end
      end
    end
  end
end


def gardetutor_movetutorannotations()
  annot = []
  for i in 0...6
    annot[i] = nil
    next if i >= $Trainer.party.length

    mon = $Trainer.party[i]
    if mon.isEgg? or mon.species != :GARDEVOIR
      text = _INTL("Not Able")
      colors = ANNOT_INELIGIBLE_COLORS
    else
        text = _INTL("Able")
        colors = ANNOT_ELIGIBLE_COLORS
    end
    annot[i] = [text, colors]
  end
  return annot
end

def gardetutor_choosetechnique
  ret=false
  pbFadeOutIn(99999){
    scene=PokemonScreen_Scene.new
    screen=PokemonScreen.new(scene,$Trainer.party)
    annot=gardetutor_movetutorannotations()
    screen.pbStartScene(_INTL("Teach which Pokémon?"),annot)
    
    loop do
      chosen = screen.pbChoosePokemon
      if chosen>=0
        pokemon=$Trainer.party[chosen]
        if pokemon.isEgg?
          Kernel.pbMessage(_INTL("Moves can't be taught to an Egg."))
        elsif (pokemon.isShadow? rescue false)
          Kernel.pbMessage(_INTL("Shadow Pokémon can't be taught any moves."))
        elsif (pokemon.species != :GARDEVOIR rescue false)
          Kernel.pbMessage(_INTL("Only Gardevoir may learn these moves."))
        else
          if gardetutor_choosemove(pokemon)
            ret=true
            break
          end
        end
      else
        break
      end
    end
    screen.pbEndScene
  }
  return ret
end

def gardetutor_choosemove(pokemon)
  retval=true
  pbFadeOutIn(99999){
    scene=GardeTutor_MoveRelearnerScene.new()
    screen=GardeTutor_MoveTutorScreen.new(scene)
    retval=screen.pbStartScreen(pokemon)
  }
  return retval
end


InjectionHelper.defineMapPatch(230) { # Chrysola Hotel
  createNewEvent(19, 17, "Gardetutor", "gardetutor_lady") { #By the front desk
    applicator = proc {
      setGraphic "NPC 31_9", direction: :Down
      walk_anime = true
      #step_anime = true
      always_on_top = true
      interact {
        text "ARCHSERVANT: Ho-ho-ho... If you have a Gardevoir, I can teach it some moves."
        text "But be warned, most of these are a little... eccentric, ho-ho-ho..."
        branch("gardetutor_choosetechnique") {
          text "ARCHSERVANT: Ho-ho-ho.."
          exit_event_processing 
        }
      }
    }

    newPage {
      requiresSwitch(1791) # Saved rift gardevoir
      instance_exec(&applicator)
    }
  }
}
