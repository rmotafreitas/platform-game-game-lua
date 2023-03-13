love.graphics.setDefaultFilter('nearest', 'nearest')

require 'player'

function love.load()
    wf = require 'libs/windfield/windfield'
    world = wf.newWorld(0, 500)

    Scale = 4
    Player.collider = world:newBSGRectangleCollider(0, 0, 20 * Scale, 26 * Scale, 7)
    Player.collider:setFixedRotation(true)

    Ground = world:newRectangleCollider(0, 500, 1920, 100)
    Ground:setType('static')

    Player:load()
end

function love.update(dt)

    local px, py = Player.collider:getLinearVelocity()

    if love.keyboard.isDown('left') and px > -300 then
        Player.collider:applyLinearImpulse(-300, 0)
    elseif love.keyboard.isDown('right') and px < 300 then
        Player.collider:applyLinearImpulse(300, 0)
    end

    world:update(dt)
    Player:update(dt)
    Player.x = Player.collider:getX() - 11 * Scale
    Player.y = Player.collider:getY() - 16 * Scale
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    Player:draw()
    world:draw()
end
