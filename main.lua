function love.load()
    world = love.physics.newWorld(0, 300, true)
    
    playerWidth = 15
    playerHeight = 50

    player1 = {}
    player1.body = love.physics.newBody(world, 200, 400)
    player1.shape = love.physics.newRectangleShape(0, 0, playerWidth, playerHeight)
    player1.fixture = love.physics.newFixture(player1.body, player1.shape, 5)
    player1.body:setAngle(math.rad(135))
    player1.playerArea = {beginning = 0, ending = 400}

    player2 = {}
    player2.body = love.physics.newBody(world, 550, 400)
    player2.shape = love.physics.newRectangleShape(0, 0, playerWidth, playerHeight)
    player2.fixture = love.physics.newFixture(player2.body, player2.shape, 5)
    player2.body:setAngle(math.rad(45))
    player2.playerArea = {beginning = 400, ending = 800}

    
    ball = {}
    ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
    ball.shape = love.physics.newCircleShape(5)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 0.001)
    ball.fixture:setRestitution(1)
    ball.body:setLinearVelocity(300, 0)
       

    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]

end

function love.draw()
    love.graphics.setColor(0, 0, 1)
    love.graphics.polygon("fill", player1.body:getWorldPoints(player1.shape:getPoints()))
    love.graphics.polygon("fill", player2.body:getWorldPoints(player2.shape:getPoints()))

    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())
    
end

function validatePlayerMovement(player, nextMoveX, nextMoveY)
    if nextMoveX >= player.playerArea.beginning
        and nextMoveX <= player.playerArea.ending - playerWidth
        and nextMoveY <= love.graphics.getHeight() - playerHeight
        and nextMoveY >= 0 then
        return true
    end
    
    return false
end

function movePlayer1()
    local nextMoveX = player1.body:getX()
    local nextMoveY = player1.body:getY()
    if love.keyboard.isDown("a") then
        nextMoveX = nextMoveX-10
    end

    if love.keyboard.isDown("s") then
        nextMoveY = nextMoveY+10
    end

    if love.keyboard.isDown("d") then
        nextMoveX = nextMoveX+10
    end

    if love.keyboard.isDown("w") then
        nextMoveY = nextMoveY-10
    end

    if joystick then
        nextMoveX = nextMoveX + joystick:getAxis(1)*10
        nextMoveY = nextMoveY + joystick:getAxis(2)*10
    end

    if validatePlayerMovement(player1, nextMoveX, nextMoveY) then
        player1.body:setX(nextMoveX)
        player1.body:setY(nextMoveY)
    end
end

function movePlayer2()
    local nextMoveX = player2.body:getX()
    local nextMoveY = player2.body:getY()
    if love.keyboard.isDown("left") then
        nextMoveX = nextMoveX-10
    end

    if love.keyboard.isDown("down") then
        nextMoveY = nextMoveY+10
    end

    if love.keyboard.isDown("right") then
        nextMoveX = nextMoveX+10
    end

    if love.keyboard.isDown("up") then
        nextMoveY = nextMoveY-10
    end

    if joystick then
        nextMoveX = nextMoveX + joystick:getAxis(3)*10
        nextMoveY = nextMoveY + joystick:getAxis(4)*10
    end

    if validatePlayerMovement(player2, nextMoveX, nextMoveY) then
        player2.body:setX(nextMoveX)
        player2.body:setY(nextMoveY)
    end
end

function love.update(dt)
    world:update(dt)

    if love.keyboard.isDown("r") then
        love.event.quit("restart")
    end
    movePlayer1()
    movePlayer2()
end