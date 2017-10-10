--The colon is for implementing methods that pass "self" as the first parameter. 
--So x:bar(3,4)should be the same as x.bar(x,3,4).

--There is one main class called GameEngine. Then there is a class for each GameEngine states

--The GameEngine class controls the game
--GameEngine has 3 states: start, play, gameover

function GameEngine()
    -- this thing in {} is a class in lua
    return {
        timer = 0,
        text = "ESCRIBIR ESTO",
        state = game_state_start,
        
        update = function(self)
            self.state.update(self)
        end,

        draw = function(self)
            self.state.draw(self)
        end,

        set_state = function(self,st)
            self.state = st
            if (st.start != nil) st.init(self)
        end
    }
end

game_state_start = {

    --Runs the first time the state starts
    init = function(self)
        --body
    end,

    update = function(self)
        --body
        self.timer += 1
    end,

    draw = function(self)
        --body
        print(0,0,self.text,11)
        print(self.timer,30,30,8)
    end,
}

game_state_play = {
    
    --Runs the first time the state starts
    init = function(self)
        --body
    end,

    update = function(self)
        --body
    end,

    draw = function(self)
        --body
    end,
}

game_state_end = {
    
    --Runs the first time the state starts
    init = function(self)
        --body
    end,

    update = function(self)
        --body
    end,

    draw = function(self)
        --body
    end,
}


function _init()
    --Create an instance of the game engine to manage the game
    game = GameEngine()
end

function _update()
  -- body
  game:update()
end

function _draw()
  -- body
  cls()
  game:draw()
end