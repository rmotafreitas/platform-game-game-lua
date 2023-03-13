Player = {
    x = 0,
    y = 0,
    scale = 4,
    speed = {
        walk = 200,
        sprint = 600
    },
    spritesheet = love.graphics.newImage('assets/sprites/sheets/reimu.png'),
    gravity = 300
}

-- States: 
-- 0 = normal 
-- 0.5 = rolling
-- 1 = sprinting

function Player:move(direction)
    local vx, vy = 0, self.gravity
    self.state.dir = direction
    self.state.dirX = direction == 'right' and 1 or -1
    if love.keyboard.isDown('lshift') then
        self.state.number = 1
        self.state.speed = self.speed.sprint
        self.state.anim = self.animations[direction].run
    else
        self.state.speed = self.speed.walk
        self.state.anim = self.animations[direction].walk
    end
    vx = self.state.dirX * self.state.speed
    self.collider:setLinearVelocity(vx, vy)
    self.state.isMoving = true
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
        dir = 'right',
        isMoving = false,
        number = 0,
        speed = self.speed.walk,
        dirX = 1
    }

    self.collider = world:newBSGRectangleCollider(0, 0, 20 * self.scale, 26 * self.scale, 7)
    self.collider:setFixedRotation(true)

    self.controls = {
        right = {
            fn = function()
                self:move('right')
            end,
            key = 'right'
        },
        left = {
            fn = function()
                self:move('left')
            end,
            key = 'left'
        },
        jump = {
            fn = function()
                print('jump')
                self.state.isMoving = true
                Player.collider:applyLinearImpulse(0, -500)
            end,
            key = 'space'
        }
    }
end

function Player:update(dt)
    self.state.number = 0
    self.state.isMoving = false
    self.x = self.collider:getX() - 11 * self.scale
    self.y = self.collider:getY() - 16 * self.scale
    for _, value in pairs(self.controls) do
        if love.keyboard.isDown(value.key) then
            value.fn()
        end
    end
    if self.state.isMoving then
        self.state.anim:update(dt)
    else
        self.state.anim:gotoFrame(1)
        self.collider:setLinearVelocity(0, self.gravity)
    end
end

function Player:draw()
    self.state.anim:draw(self.spritesheet, self.x, self.y, nil, 4)
end
