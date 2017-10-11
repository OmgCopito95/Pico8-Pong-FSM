--The colon is for implementing methods that pass "self" as the first parameter. 
--So x:bar(3,4)should be the same as x.bar(x,3,4).

--There is one main class called GameEngine. Then there is a class for each GameEngine states

--The GameEngine class controls the game
--GameEngine has 3 states: start, play, gameover


function GameEngine()
    -- this thing in {} is a class in lua
    return {
        timer = 0,
        blink_speed = 20,
        state = game_state_start,
        
        update = function(self)
            self.state.update(self)
        end,

        draw = function(self)
            self.state.draw(self)
        end,

        set_state = function(self,st)
            self.timer = 0
            self.state = st
            --If state contains init method, run it
            if (st.init != nil) st.init(self)
        end
    }
end

game_state_start = {
    --Runs the first time the state starts
    init = function(self)
        --body
        self.blink_speed = 20
    end,

    update = function(self)
        --body
        self.timer += 1
        --self.timer = self.timer % self.blink_speed
        if (btn(4) or btn(5)) and self.blink_speed ~= 2 then
            self.blink_speed = 2
            self.timer = 0
            --sfx()
        end
        if self.timer > 30 and self.blink_speed == 2 then
            self:set_state(game_state_play)
        end
    end,

    draw = function(self)
        --body
        if self.timer % self.blink_speed < self.blink_speed/2  then
            print("press action to start",22,90,7)
        end
    end,
}

game_state_play = {    
    --Runs the first time the state starts
    init = function(self)
        --create a player instance, will be used until gameover
        --"player" belongs to a GameEngine attribute
        self.player = Player()
        self.ball = Ball()
        self.player:set_state(player_state_freeze)
    end,

    update = function(self)
        --use : to send the "player" data
        self.player:update()
        self.ball:update()

        if self.player.lives == 0 then
            self:set_state(game_state_end)
        end

        if self.ball.state == ball_state_move then
            --collition system
            local bx = self.ball.x
            local by = self.ball.y
            local bdirec = self.ball.direc
            local px = self.player.x
            local py = self.player.y
            local pw = self.player.w
            --local ph = self.player.h
            if (bx > 123) bdirec[1] = -1
            if (bx < 3) bdirec[1] = 1
            if (by < 4) bdirec[2] = 1
            --if by >= py-ph and by <= py+ph and bx >= px-pw and bx <= px+pw then
            if by >= py-4 and by <= py+4 and bx >= px-pw+2 and bx <= px+pw-2 then
                --bounce at player
                self.ball.direc[2] = -1
            elseif by >= 128 then
                self.player.lives -= 1
                self.player:set_state(player_state_freeze)
                self.ball:set_state(ball_state_die)
            end
        end
    end,

    draw = function(self)
        --body
        self.player:draw()
        self.ball:draw()
    end,
}

game_state_end = {    
    --Runs the first time the state starts
    init = function(self)
        --body
    end,

    update = function(self)
        --body
        if btn(4) or btn(5) then
            self:set_state(game_state_start)
        end
    end,

    draw = function(self)
        --body
        rectfill(0,61,127,67,1)
        print("game over",46,62,7)
    end,
}


function Player()
    -- this thing in {} is a class in lua
    return {
        x = 64,
        y = 124,
        w = 10,
        h = 2,
        speed = 4,
        lives = 3,
        timer = 0,
        
        update = function(self)
            self.state.update(self)
        end,

        draw = function(self)
            self.state.draw(self)
        end,

        set_state = function(self,st)
            self.timer = 0
            self.state = st
            if (st.init != nil) st.init(self)
        end
    }
end

player_state_freeze = {    
    --Runs the first time the state starts
    init = function(self)
        --body
        self.x = 64
    end,

    update = function(self)
        --body
        self.timer += 1
        if self.timer > 60 then
            --self.timer = 0
            self:set_state(player_state_move)
        end
    end,

    draw = function(self)
        print("Ready...",50,60)
        --draw lives
        for i=1,self.lives do
            spr(1,80+i*10,2)
        end
        rectfill(self.x-self.w,self.y+self.h,self.x+self.w,self.y-self.h,8)
    end,
}

player_state_move = {    
    --Runs the first time the state starts
    init = function(self)
        --body
    end,

    update = function(self)
        self.timer += 1
        --manage user input
        if self.timer > 9 then
            if (btn(0)) self.x -= self.speed
            if (btn(1)) self.x += self.speed
        end
    end,

    draw = function(self)
        --body
        if self.timer < 10 then
            print("Go!",60,60,8)
        end
        rectfill(self.x-self.w,self.y+self.h,self.x+self.w,self.y-self.h,8)
    end,
}

function Ball()
    -- this thing in {} is a class in lua
    return {
        x = 64,
        y = 119,
        r = 2,
        direc = {1,-1},
        speed = 4,
        timer = 0,
        state = ball_state_die,
        
        update = function(self)
            self.state.update(self)
        end,

        draw = function(self)
            self.state.draw(self)
        end,

        set_state = function(self,st)
            self.timer = 0
            self.state = st
            if (st.init != nil) st.init(self)
        end
    }
end

ball_state_die = {    
    --Runs the first time the state starts
    init = function(self)
        --body
        self.x = 64
        self.y = 119
        self.direc = {1,-1}
    end,

    update = function(self)
        --body
        self.timer += 1
        if self.timer > 60 then
            --self.timer = 0
            self:set_state(ball_state_move)
        end
    end,

    draw = function(self)
        --body
        if self.timer > 30 then
            circfill(self.x,self.y,self.r,8)
        end
    end,
}

ball_state_move = {    
    --Runs the first time the state starts
    init = function(self)
        --body
    end,

    update = function(self)
        self.timer += 1
        self.x += self.speed * self.direc[1]
        self.y += self.speed * self.direc[2]
    end,

    draw = function(self)
        --draw ball
        circfill(self.x,self.y,self.r,8)
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

