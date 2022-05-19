WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')  

    love.window.setTitle('Pong')

    smallFont = love.graphics.newFont('font.TTF', 8)

    scoreFont = love.graphics.newFont('font.TTF', 32)

    victoryFont = love.graphics.newFont('font.TTF', 24)

    player1Score = 0
    player2Score = 0

    servingPlayer = math.random(2) == 1 and 1 or 2

    winningPlayer = 0
    

    paddle1 = Paddle(5, 20, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end
    
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and -100 or 100
    ballDY = math.random(-50, 50)
     
    gameState = 'start'

    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    })
end

function love.update(dt)

    if ball:collides(paddle1) then
        ball.dx = -ball.dx
    end

    if ball:collides(paddle2) then 
        ball.dx = -ball.dx
    end

    if ball.y <=0 then 
        ball.dy = -ball.dy
        ball.y = 0
    end

    if ball.y >= VIRTUAL_HEIGHT -4 then 
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
    end
    paddle1:update(dt)
    paddle2:update(dt)
    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
    else
        paddle1.dy = 0

    end
    
    if love.keyboard.isDown('up') then
        paddle2.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('down') then
        paddle2.dy = PADDLE_SPEED
    else
        paddle2.dy = 0

    end

    if gameState == 'play' then

        if ball.x < 0 then
            player2Score = player2Score + 1
            servingPlayer = 1
            ball:reset()
            if player2Score >= 10 then
                gameState ='victory'
                winningPlayer = 2
            else
            ball.dx = 100
            gameState = 'serve'
            end
        end

        if ball.x > VIRTUAL_WIDTH - 4 then
            player1Score = player1Score + 1
            servingPlayer = 2
            ball:reset()
            if player1Score >= 10 then
                gameState ='victory'
                winningPlayer = 1
            else
            ball.dx = -100
            gameState = 'serve'
            end
        end
        ball:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then

        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'victory' then 
            gameState = 'start'
            player1Score = 0
            player2Score = 0
        elseif gameState == 'serve' then 
            gameState = 'play' 
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.clear(40 / 255 , 45 / 255, 52 / 255, 255 / 255)

    ball:render()


    paddle1:render()
    paddle2:render()

    displayFPS()

    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf("Welcome To Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter To Play!", 0, 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s turn!", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Player Enter to Serve!", 0, 32, VIRTUAL_WIDTH, 'center') 
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins", 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player Enter to Serve!", 0, 42, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS '.. tostring(love.timer.getFPS()), 40, 20)
    love.graphics.setColor(1, 1, 1, 1)    
end