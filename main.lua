function love.load()
    world = love.physics.newWorld(0, 300, true)
    
    playerWidth = 15
    playerHeight = 50

    player1 = {}
    player1.body = love.physics.newBody(world, 200, 400, "kinematic")
    player1.shape = love.physics.newRectangleShape(0, 0, playerWidth, playerHeight)
    player1.fixture = love.physics.newFixture(player1.body, player1.shape, 2)
    player1.body:setAngle(math.rad(135))
    player1.playerArea = {beginning = 0, ending = 400}

    player2 = {}
    player2.body = love.physics.newBody(world, 550, 400, "kinematic")
    player2.shape = love.physics.newRectangleShape(0, 0, playerWidth, playerHeight)
    player2.fixture = love.physics.newFixture(player2.body, player2.shape, 2)
    player2.body:setAngle(math.rad(45))
    player2.playerArea = {beginning = 400, ending = 800}

    
    ball = {}
    ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
    ball.shape = love.physics.newCircleShape(5)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
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

function validateDeadzone(axis1, axis2)
    return (math.abs(axis1) >= 0.03 and math.abs(axis2) >= 0.03)
end

function movePlayer1()
    local linearVelocityX = 0
    local linearVelocityY = 0
    if love.keyboard.isDown("a") then
        linearVelocityX = -1000
    end

    if love.keyboard.isDown("s") then
        linearVelocityY = 1000
    end

    if love.keyboard.isDown("d") then
        linearVelocityX = 1000
    end

    if love.keyboard.isDown("w") then
        linearVelocityY = -1000
    end

    if love.keyboard.isDown("a", "s", "d", "w") then
        player1.body:setLinearVelocity(linearVelocityX, linearVelocityY)
    elseif joystick and validateDeadzone(joystick:getAxis(1), joystick:getAxis(2)) then
        player1.body:setLinearVelocity(joystick:getAxis(1)*1000, joystick:getAxis(2)*1000)
    else 
        player1.body:setLinearVelocity(0, 0)
    end
end

function movePlayer2()
    local linearVelocityX = 0
    local linearVelocityY = 0
    if love.keyboard.isDown("left") then
        linearVelocityX = -1000
    end

    if love.keyboard.isDown("down") then
        linearVelocityY = 1000
    end

    if love.keyboard.isDown("right") then
        linearVelocityX = 1000
    end

    if love.keyboard.isDown("up") then
        linearVelocityY = -1000
    end

    if love.keyboard.isDown("left", "down", "right", "up") then
        player2.body:setLinearVelocity(linearVelocityX, linearVelocityY)
    elseif joystick and validateDeadzone(joystick:getAxis(3), joystick:getAxis(4)) then
        player2.body:setLinearVelocity(joystick:getAxis(3)*1000, joystick:getAxis(4)*1000)
    else 
        player2.body:setLinearVelocity(0, 0)
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