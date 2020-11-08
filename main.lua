function love.load()
    world = love.physics.newWorld(0, 300, true)
    
    playerWidth = 15
    playerHeight = 50

    joysticks = love.joystick.getJoysticks()
    joystick = joysticks[1]
    gamepad1 = {xAxis = 1, yAxis = 2}
    gamepad2 = {xAxis = 3, yAxis = 4}


    player1 = {}
    player1.body = love.physics.newBody(world, 200, 400, "kinematic")
    player1.shape = love.physics.newRectangleShape(0, 0, playerWidth, playerHeight)
    player1.fixture = love.physics.newFixture(player1.body, player1.shape, 2)
    player1.body:setAngle(math.rad(135))
    player1.playerArea = {beginning = 0, ending = 400}
    player1.controls = {keyboard = {up = "w", left = "a", down = "s", right = "d"}, gamepad = gamepad1}

    player2 = {}
    player2.body = love.physics.newBody(world, 550, 400, "kinematic")
    player2.shape = love.physics.newRectangleShape(0, 0, playerWidth, playerHeight)
    player2.fixture = love.physics.newFixture(player2.body, player2.shape, 2)
    player2.body:setAngle(math.rad(45))
    player2.playerArea = {beginning = 400, ending = 800}
    player2.controls = {keyboard = {up = "up", left = "left", down = "down", right = "right"}, gamepad = gamepad2}

    
    ball = {}
    ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
    ball.shape = love.physics.newCircleShape(5)
    ball.fixture = love.physics.newFixture(ball.body, ball.shape, 1)
    ball.fixture:setRestitution(1)
    ball.body:setLinearVelocity(300, 0)
       



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

function validateDeadzone(controller)
    return (math.abs(joystick:getAxis(controller.xAxis)) >= 0.04 and math.abs(joystick:getAxis(controller.yAxis)) >= 0.04)
end

function movePlayer(player)
    local linearVelocityX = 0
    local linearVelocityY = 0
    
    playerkb = player.controls.keyboard

    if love.keyboard.isDown(playerkb.left) then
        linearVelocityX = -1000
    end

    if love.keyboard.isDown(playerkb.down) then
        linearVelocityY = 1000
    end

    if love.keyboard.isDown(playerkb.right) then
        linearVelocityX = 1000
    end

    if love.keyboard.isDown(playerkb.up) then
        linearVelocityY = -1000
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
end