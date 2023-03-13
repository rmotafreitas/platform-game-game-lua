Player = {
    x = 10,
    y = love.graphics.getHeight() - 200,
    speed = {
        walk = 200,
        sprint = 600
    },
    spritesheet = love.graphics.newImage('assets/sprites/sheets/reimu.png'),
    gravity = -800,
}

-- States: 
-- 0 = normal 
-- 0.5 = rolling
-- 1 = sprinting

function Player:move(dt, direction)
    self.state.direction = direction
    self.state.dirX = direction == 'right' and 1 or -1
end

function Player:load()
    local anim8 = require 'libs/anim8'

    self.grid = anim8.newGrid(24, 32, Player.spritesheet:getWidth(), self.spritesheet:getHeight())
    self.animations = {
        right = {
            walk = anim8.newAnimation(self.grid('1-4', 3), 0.2),
            run = anim8.newAnimation(self.grid('1-4', 3), 0.05),
            roll = anim8.newAnimation(self.grid('5-8', 3), 0.2),
        },
        left = {
            walk = anim8.newAnimation(self.grid('1-4', 7), 0.2),
            run = anim8.newAnimation(self.grid('1-4', 7), 0.05),
            roll = anim8.newAnimation(self.grid('5-8', 7), 0.1),
        }
    }

    self.state = {
        anim = self.animations.right.walk,
        direction = 'right',
        isMoving = false,
        number = 0,
        speed = self.speed.walk,
        dirX = 1
    }


    self.moviment = {
        right = {
            fn = function(dt)
                self:move(dt, 'right')
            end,
            key = 'right'
        },
        left = {
            fn = function(dt)
                self:move(dt, 'left')
            end,
            key = 'left'
        },
        sprint = {
            fn = function(dt)
                self.state.number = 1
            end,
            key = 'lshift'
        },
        jump = {
            fn = function(dt)
            end,
            key = 'space'
        }
    }
end

function Player:update(dt)
    self.state.number = 0
end



function Player:draw()
    self.state.anim:draw(self.spritesheet, self.x, self.y, nil, 4)
end
