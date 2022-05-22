
Player = Class{}

function Player:init(map)
    
    self.x = 0
    self.y = 0
    self.width = 16
    self.height = 20

    self.xOffset = 8
    self.yOffset = 16

    self.map = map
    self.texture = love.graphics.newImage('graphics/blue_alien.png')

    self.frames = {}

    self.currentFrame = nil

    self.state = 'idle'

    self.direction = 'left'

    self.dx = 0
    self.dy = 0

    self.y = map.tileHeight * ((map.mapHeight - 2) / 2) - self.height
    self.x = map.tileWidth * 10

    self.frames = {
        love.graphics.newQuad(144, 0, 16, 20, self.texture:getDimensions())
    }

    self.currentFrame = self.frames[1]

    self.behaviors = {
        ['idle'] = function(dt)
            
            if love.keyboard.isDown('left') then
                self.direction = 'left'
                self.dx = -80
            elseif love.keyboard.isDown('right') then
                self.direction = 'right'
                self.dx = 80
            else
                self.dx = 0
            end
        end
    }
end

function Player:update(dt)
    self.behaviors[self.state](dt)

    self.x = self.x + self.dx * dt
end

function Player:render()
    local scaleX

    if self.direction == 'right' then
        scaleX = 1
    else
        scaleX = -1
    end

    love.graphics.draw(self.texture, self.currentFrame, math.floor(self.x + self.xOffset),
        math.floor(self.y + self.yOffset), 0, scaleX, 1, self.xOffset, self.yOffset)
end