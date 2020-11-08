--prints colliding fixtures info and collision position
function beginContact(a, b, coll)
    local x,y = coll:getPositions()
    print(a:getUserData().." colliding with "..b:getUserData().." "..x..", "..y)
end

function love.load()
    world = love.physics.newWorld(0, 300, true)
    world:setCallbacks(beginContact)
    
    playerWidth = 15
    playerHeight = 50

    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
    gamepad1 = {xAxis = 1, yAxis = 2}
    gamepad2 = {xAxis = 3, yAxis = 4}

    player1 = {}
    player1.body = love.physics.newBody(world, 200, 400, "dynamic")
    player1.shape = love.physics.newRectangleShape(0, 0, playerWidth, playerHeight)
    player1.fixture = love.physics.newFixture(player1.body, player1.shape, 2)
    -- player1.body:setAngle(math.rad(135))
    player1.body:setFixedRotation(true)
    player1.body:setGravityScale(0)
    player1.playerArea = {beginning = 0, ending = 400}
    player1.controls = {keyboard = {up = "w", left = "a", down = "s", right = "d"}, gamepad = gamepad1}
    player1.fixture:setUserData('P1')

    player2 = {}
    player2.body = love.physics.newBody(world, 550, 400, "dynamic")
    player2.shape = love.physics.newRectangleShape(0, 0, playerWidth, playerHeight)
    player2.fixture = love.physics.newFixture(player2.body, player2.shape, 2)
    -- player2.body:setAngle(math.rad(45))
    player2.body:setFixedRotation(true)
    player2.body:setGravityScale(0)
    player2.playerArea = {beginning = 400, ending = 800}
    player2.controls = {keyboard = {up = "up", left = "left", down = "down", right = "right"}, gamepad = gamepad2}
    player2.fixture:setUserData('P2')
    
    ball = {}
    ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
    ball.shape = love.physics.newCircleShape(5)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setRestitution(1)
    ball.body:setGravityScale(0)
    ball.fixture:setUserData('ball')
       
    gameTable = {}
    gameTable.body = love.physics.newBody(world, 400, 450)
    gameTable.shape = love.physics.newRectangleShape(0, 0, 500, 20)
    gameTable.fixture = love.physics.newFixture(gameTable.body, gameTable.shape, 5)
    gameTable.fixture:setUserData('table')

    net = {}
    net.body = love.physics.newBody(world, 400, 415)
    net.shape = love.physics.newRectangleShape(0, 0, 20, 70)
    net.fixture = love.physics.newFixture(net.body, net.shape, 5)
    net.fixture:setUserData('net')

end

function love.draw()
    love.graphics.setColor(0, 0, 1)
    love.graphics.polygon("fill", player1.body:getWorldPoints(player1.shape:getPoints()))
    love.graphics.polygon("fill", player2.body:getWorldPoints(player2.shape:getPoints()))

    love.graphics.setColor(0, 1, 0)
    love.graphics.circle("fill", ball.body:getX(), ball.body:getY(), ball.shape:getRadius())

    love.graphics.setColor(1, 1, 1)
    love.graphics.polygon("fill", gameTable.body:getWorldPoints(gameTable.shape:getPoints()))
    love.graphics.polygon("fill", net.body:getWorldPoints(net.shape:getPoints()))
    
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

function validateDeadzone(controller)
    return (math.abs(joystick:getAxis(controller.xAxis)) >= 0.04 and math.abs(joystick:getAxis(controller.yAxis)) >= 0.04)
end

function movePlayer(player)
    local linearVelocityX = 0
    local linearVelocityY = 0
    
    playerkb = player.controls.keyboard

    if love.keyboard.isDown(playerkb.left) then
        linearVelocityX = -200
    end

    if love.keyboard.isDown(playerkb.down) then
        linearVelocityY = 200
    end

    if love.keyboard.isDown(playerkb.right) then
        linearVelocityX = 200
    end

    if love.keyboard.isDown(playerkb.up) then
        linearVelocityY = -200
    end

    playerGmpd = player.controls.gamepad

    if love.keyboard.isDown(playerkb.left, playerkb.down, playerkb.right, playerkb.up) then
        player.body:setLinearVelocity(linearVelocityX, linearVelocityY)
    elseif joystick and validateDeadzone(playerGmpd) then
        player.body:setLinearVelocity(joystick:getAxis(playerGmpd.xAxis)*1000, joystick:getAxis(playerGmpd.yAxis)*1000)
    else 
        player.body:setLinearVelocity(0, 0)
    end
end

function love.update(dt)
    world:update(dt)

    if love.keyboard.isDown("r") then
        love.event.quit("restart")
    end
    movePlayer(player1)
    movePlayer(player2)

    --if ball go off the screen, reset it's initial status
    local x, y = ball.body:getPosition()
    if x < 0 or x > 800 or y < 0 or y > 600 then
        ball.body:setPosition(650/2, 650/2)
        ball.body:setLinearVelocity(0, 0)
        ball.body:setGravityScale(0)
    end

    --if ball is moving, guarantee it's following gravity
    local vx, vy = ball.body:getLinearVelocity()
    if vx ~= 0 or vy ~= 0 then
        ball.body:setGravityScale(1)
    end
end