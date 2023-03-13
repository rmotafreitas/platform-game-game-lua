love.graphics.setDefaultFilter('nearest', 'nearest')

require 'player'

function love.load()
    wf = require 'libs/windfield/windfield'
    sti = require 'libs/sti/sti'
    gameMap = sti('maps/map.lua')
    world = wf.newWorld(0, 500)

    walls = {}
    mapScale = 3

    for _, obj in pairs(gameMap.layers['walls'].objects) do
        local wall = world:newRectangleCollider(obj.x * mapScale, obj.y * mapScale, obj.width * mapScale, obj.height * mapScale)
        wall:setType('static')
        table.insert(walls, wall)
    end

    Player:load()
end

function love.update(dt)
    world:update(dt)
    Player:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(mapScale)
    gameMap:drawLayer(gameMap.layers['Tile Layer 1'])
    gameMap:drawLayer(gameMap.layers['Tile Layer 2'])
    love.graphics.pop()
    Player:draw()
end
