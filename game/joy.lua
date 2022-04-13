
-- Project: vjoy 0.3
--
-- Date: Mar 3, 2015
-- Updated: Nov 21, 2016

local M = {}
local stage = display.getCurrentStage()
local controler = require('game.function')

function M.newButton(radius , image , key)

  local instance = display.newGroup()
  radius = radius
  key = key

  if type(radius) == "number" then
    local khung = display.newCircle(instance,0,0, radius)
    local weapon = display.newImage(instance, image, 0,0 )
    khung:setFillColor( 0.2, 0.2, 0.2, 0.9 )
    khung.strokeWidth = 1
    khung:setStrokeColor( 1, 1, 1, 1 )
  end

  function instance:touch(event)
    local phase = event.phase
    if phase=="began" then
      if event.id then stage:setFocus(event.target, event.id) end
      instance._xScale, instance._yScale = instance.xScale, instance.yScale
      instance.xScale, instance.yScale = instance.xScale * 0.95, instance.yScale * 0.95
      local keyEvent = {name = "key", phase = "down", keyName = key or "none"}
      Runtime:dispatchEvent(keyEvent)
    elseif phase=="ended" or phase == "cancelled" then
      if event.id then stage:setFocus(nil, event.id) end
      instance.xScale, instance.yScale = instance._xScale, instance._yScale
      local keyEvent = {name = "key", phase = "up", keyName = key or "none"}
      Runtime:dispatchEvent(keyEvent)
    end
    return true
  end

  function instance:activate()
    self:addEventListener("touch")
  end

  function instance:deactivate()
    self:removeEventListener("touch")
  end
  instance.alpha = 0.5
  instance:activate()
  return instance
end

function M.newStick(startAxis, innerRadius, outerRadius)
  startAxis = startAxis or 1
  innerRadius, outerRadius =  26, 37
  local instance = display.newGroup()

  local outerArea 
  if type(outerRadius) == "number" then
    outerArea = display.newCircle( instance, 0,0, outerRadius )
    outerArea:setFillColor( 0.2, 0.2, 0.2, 0.9 )
  else
    outerArea = display.newImage( instance, outerRadius, 0,0 )
    outerRadius = (outerArea.contentWidth + outerArea.contentHeight) * 0.25
  end

  local joystick 
  if type(innerRadius) == "number" then
    joystick = display.newCircle( instance, 0,0, innerRadius )
    joystick:setFillColor( 0.4, 0.4, 0.4, 0.9 )
  else
    joystick = display.newImage( instance, innerRadius, 0,0 )
    innerRadius = (joystick.contentWidth + joystick.contentHeight) * 0.25
  end  

  -- where should joystick motion be stopped?
  local stopRadius = outerRadius - innerRadius

  function joystick:touch(event)
    local phase = event.phase
    if phase=="began" or (phase=="moved" and self.isFocus) then
      if phase == "began" then
        stage:setFocus(event.target, event.id)
        self.eventID = event.id
        self.isFocus = true
      end
      local parent = self.parent
      local posX, posY = parent:contentToLocal(event.x, event.y)
      local angle = -math.atan2(posY, posX)
      instance.angle = math.atan2(posY, posX)
      local distance = math.sqrt((posX*posX)+(posY*posY))

      if( distance >= stopRadius ) then
        distance = stopRadius
        self.x = distance*math.cos(angle)
        self.y = -distance*math.sin(angle)
        
      else
        self.x = posX
        self.y = posY
      end
    else
      instance.angle = nil
      self.x = 0
      self.y = 0
      stage:setFocus(nil, event.id)
      self.isFocus = false
    end
    instance.axisX = self.x / stopRadius
    instance.axisY = self.y / stopRadius
    local axisEvent
    if not (self.y == (self._y or 0)) then
      axisEvent = {name = "move", axis = { number = startAxis }, normalizedValue = instance.axisX }
      Runtime:dispatchEvent(axisEvent)
    end
    if not (self.x == (self._x or 0))  then 
      axisEvent = {name = "move", axis = { number = startAxis+1 }, normalizedValue = instance.axisY }
      Runtime:dispatchEvent(axisEvent)
    end
    self._x, self._y = self.x, self.y
    return true
  end

  function instance:activate()
    self:addEventListener("touch", joystick )
    self.axisX = 0
    self.axisY = 0
  end

  function instance:deactivate()
    stage:setFocus(nil, joystick.eventID)
    joystick.x, joystick.y = outerArea.x, outerArea.y
    self:removeEventListener("touch", self.joystick )
    self.axisX = 0
    self.axisY = 0
  end
  instance.alpha=0.7
  instance:activate()
  return instance
end

function M.newSkill(startAxis, innerRadius, outerRadius)
  startAxis = startAxis or 1
  innerRadius, outerRadius =  display.contentWidth / 10, display.contentHeight /10
  local instance = display.newGroup()

  local outerArea 
  if type(outerRadius) == "number" then
    outerArea = display.newCircle( instance, 0,0, outerRadius )
    outerArea:setFillColor( 0.2, 0.2, 0.2, 0.9 )
  else
    outerArea = display.newImage( instance, outerRadius, 0,0 )
    outerRadius = (outerArea.contentWidth + outerArea.contentHeight) * 0.25
  end

  local joystick 
  if type(innerRadius) == "number" then
    joystick = display.newCircle( instance, 0,0, innerRadius )
    joystick:setFillColor( 0.4, 0.4, 0.4, 0.9 )
    joystick.isVisible = false
  else
    joystick = display.newImage( instance, innerRadius, 0,0 )
    innerRadius = (joystick.contentWidth + joystick.contentHeight) * 0.25
  end  

  -- where should joystick motion be stopped?
  local stopRadius = outerRadius - innerRadius

  function joystick:touch(event)
    local phase = event.phase
    if (phase=="began" or (phase=="moved" and self.isFocus)) then
      if phase == "began" then
        stage:setFocus(event.target, event.id)
        self.eventID = event.id
        self.isFocus = true
      end
      local parent = self.parent
      local posX, posY = parent:contentToLocal(event.x, event.y)
      local angle = -math.atan2(posY, posX)
      instance.angle = math.atan2(posY, posX)
      instance.posX , instance.posY = posX, posY
      local distance = math.sqrt((posX*posX)+(posY*posY))
      if( distance >= stopRadius ) then
        distance = stopRadius
        self.x = distance*math.cos(angle)
        self.y = -distance*math.sin(angle)
        local axisEvent
        if instance.posX * instance.posX + instance.posY * instance.posY  > outerRadius*outerRadius then
          axisEvent = {name = "axis", angle = math.atan2(-self.y, -self.x), phase = 'moved' }
          Runtime:dispatchEvent(axisEvent)
        end
      else
        self.x = posX
        self.y = posY
      end
    else
      instance.angle = nil
      stage:setFocus(nil, event.id)
      self.isFocus = false
    end
    instance.axisX = self.x / stopRadius
    instance.axisY = self.y / stopRadius
    if phase=="ended" then
      local axisEvent
        axisEvent = {name = "axis", angle = math.atan2(-self.y, -self.x), phase = 'ended' }
        Runtime:dispatchEvent(axisEvent)
    end
    self._x, self._y = self.x, self.y
    return true
  end

  function instance:activate()
    self:addEventListener("touch", joystick )
    self.axisX = 0
    self.axisY = 0
  end

  function instance:deactivate()
    stage:setFocus(nil, joystick.eventID)
    joystick.x, joystick.y = outerArea.x, outerArea.y
    self:removeEventListener("touch", self.joystick )
    self.axisX = 0
    self.axisY = 0
  end
  instance.alpha=0.7
  instance:activate()
  return instance
end


return M
