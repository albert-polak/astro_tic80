-- title:   game title
-- author:  Albert Polak, lugii1999@gmail.com, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua
-- DISPLAY   240x136

map_w, map_h=1920, 1088
camera_x, camera_y=0, 0
old_camera_x, old_camera_y=0,0
old_scale_factor=1

telescope_radius=50

scale_factor=1

minimap_scale=4
minimap_x=172
minimap_y=8

min_x=camera_x
max_x=camera_x+240
min_y=camera_y
max_y=camera_y+136


random=math.random
sin=math.sin
cos=math.cos
pi=math.pi
abs=math.abs

_mouse=mouse()

planets={}
no_planets=20
goal_planet=1
show_goal=false
zoom_animation_flag=false
win_flag=false

goal_error=100
time_limit=60
time_limit_multiplier=2
score=0

stars={}
no_stars=500

t=0
t2=0
x=96
y=24

function fillPlanets()
	for i=1, no_planets do
		planets[i]={
			x=random(20,map_w-20),
			y=random(20,map_h-20),
			radius=random(5, 20),
			ring_h=random(0,100),
			ring_w=random(0,100),
			ring_dist= 40,
			ring_width=random(0,10),
			ring_color=random(1,16),
			color=random(1,15),
			border=random(1,15),
			inner=random(1,15),
			border_size=random(0,5),
			inner_size=random(0,5)
		}
	end
end

function drawPlanet(tmp)
	s=scale_factor
	circ(tmp.x/s-camera_x, 
			tmp.y/s-camera_y+2*sin(t)/s, 
		(tmp.radius+tmp.border_size)/(s*s),
		 tmp.border)
	circ(tmp.x/s-camera_x, 
		tmp.y/s-camera_y+2*sin(t)/s, 
		tmp.radius/(s*s),
	 tmp.color)
	circ(tmp.x/s-camera_x, 
		tmp.y/s-camera_y+2*sin(t)/s, 
	(tmp.radius-tmp.inner_size)/(s*s),
	 tmp.inner)
end


function drawPlanets()
	for i=1, no_planets do
	s=scale_factor
	tmp=planets[i]
	if (tmp.x>=min_x*s and 
				tmp.x<=max_x*s) and 
				(tmp.y>=min_y*s and 
				tmp.y<=max_y*s)
		then
		
		drawPlanet(tmp)
		if s<6 then
			drawRing(tmp)
		end
	end
	end
end

function drawStars()
	for i=1, no_stars do
		s=scale_factor
		tmp=stars[i]
		if (tmp.x>=min_x*s and 
					tmp.x<=max_x*s) and 
					(tmp.y>=min_y*s and 
					tmp.y<=max_y*s)
			then
			
			circ(tmp.x/s-camera_x, 
								tmp.y/s-camera_y, 
							(tmp.size)/s,
			 				tmp.color)	
		end
	end
end

function drawRing(tmp)
	s=scale_factor
	for i=tmp.ring_dist/(1),
	 (tmp.ring_dist+tmp.ring_width)/(1) do
		-- angle
		for j=0, 720/s do
			pixel_colour=
			pix(formula_x, formula_y)
			
			formula_x=tmp.x/s-camera_x+
			i*cos(j*pi/360*s)*tmp.ring_w/100/(s*s)
			formula_y=tmp.y/s-camera_y+2*sin(t)/s+
			i*sin(j*pi/360*s)*tmp.ring_h/100/(s*s)
			if tmp.ring_w>tmp.ring_h then
				if (pixel_colour==0 and j>360/s)then
					pix(formula_x, 
					formula_y, 
					tmp.ring_color)
				end
				if j<360/s then
					pix(formula_x, 
					formula_y, 
					tmp.ring_color)
				end
			else 
				if (pixel_colour==0 and 
				(j<180/s or j>520/s))then
					pix(formula_x, 
					formula_y, 
					tmp.ring_color)
				end
				if (j>180/s and j<520/s) then
					pix(formula_x, 
					formula_y, 
					tmp.ring_color)
				end
			end	
		end

	end
end

function drawGoalRing(tmp,x,y)
	s=1
	for i=tmp.ring_dist/s,
	 (tmp.ring_dist+tmp.ring_width)/s do
		-- angle
		for j=0, 720 do
			pixel_colour=
			pix(formula_x, formula_y)
			
			formula_x=x+
			i*cos(j*pi/360)*tmp.ring_w/100/s
			formula_y=y+2*sin(t)/s+
			i*sin(j*pi/360)*tmp.ring_h/100/s
			if tmp.ring_w>tmp.ring_h then
				if (pixel_colour==0 and j>360)then
					pix(formula_x, 
					formula_y, 
					tmp.ring_color)
				end
				if j<360 then
					pix(formula_x, 
					formula_y, 
					tmp.ring_color)
				end
			else 
				if (pixel_colour==0 and 
				(j<180 or j>520))then
					pix(formula_x, 
					formula_y, 
					tmp.ring_color)
				end
				if (j>180 and j<520) then
					pix(formula_x, 
					formula_y, 
					tmp.ring_color)
				end
			end	
		end
	end
end

function drawMinimap(x, y)
	s=30
	
	rectb(x,y,240/minimap_scale,
		136/minimap_scale,12)
	rectb(x+camera_x/s*scale_factor,
							y+camera_y/s*scale_factor,
							240/s*scale_factor,
		136/s*scale_factor,12)
	for i=1, no_planets do
		tmp=planets[i]
		circ(tmp.x/s+x,
		 	tmp.y/s+y, 
			(tmp.radius)/s,
		 4)
				
	end
end

function drawTelescope()
	for i=0, 240 do
		for j=0, 136 do
			dx = abs(i-120+sin(t))
			dy = abs(j-68+sin(t))
			R = telescope_radius
			if (dx>R or dy>R) then
				pix(i,j,15)
				goto continue
			end
			if dx^2+dy^2<=R^2 then
				if dx^2+dy^2-R^2>-150 then
					pix(i,j,13)
				end
				goto continue
			end
			pix(i,j,15)
			::continue::
		end 
	end
end

function drawGoalPlanet(x,y)
	tmp=planets[goal_planet]
	s=1
	circ(x, 
			y+sin(t), 
		(tmp.radius+tmp.border_size)/s,
		 tmp.border)
	circ(x, 
		y+sin(t), 
		tmp.radius/s,
	 tmp.color)
	circ(x, 
		y+sin(t), 
	(tmp.radius-tmp.inner_size)/s,
	 tmp.inner)
	
		drawGoalRing(tmp, x, y)
end

function zoomAnimation()
	if zoom_animation_flag==true then
		rect(240*sin(t2*4),0,
							240*sin(t2*4),136, 15)
		--circ(120,136,200*sin(t2*4),13)
	end
	if t2>0.4 then
		zoom_animation_flag=false
	end
end

function BOOT()
	fillPlanets()
	--planets[2].x=100
	--planets[2].y=100
	--planets[3].x=960
	--planets[3].y=544
	
	for i=1, no_stars do
		stars[i]={x=random(-240,map_w+240),
												y=random(-136,map_h+136),
												size=random(0,1),
												color=random(12,15)}
	end
	
	goal_planet=random(1,no_planets)
end

function updateRenderBounds()
	min_x=camera_x
	max_x=camera_x+240
	min_y=camera_y
	max_y=camera_y+136
end

function updateCameraPos(zoom)
	if zoom == true then
		camera_x=camera_x+camera_x
										/scale_factor+240/2
										/(scale_factor)
		camera_y=camera_y+camera_y
										/scale_factor+136/2
										/(scale_factor)
	else
		camera_x=camera_x-camera_x
										/scale_factor-240/2
										/(scale_factor)
		camera_y=camera_y-camera_y
										/scale_factor-136/2
										/(scale_factor)
	end
end

function checkGoal()
	tmp=planets[goal_planet]
	if (abs(camera_x-tmp.x+120)<goal_error)
		and (abs(camera_y-tmp.y+78)<goal_error)then
		win_flag=true
		BOOT()
	end
end

function timeLimit()
	tlm=time_limit_multiplier
	rect(59,119,122,7,4)
	if t*tlm<time_limit then
		rect(60,120,120*t/(120/tlm/2),5,5)
	end
end

function TIC()
	if btn(0) then 
		if camera_y+136/2-1*scale_factor>0 then
			camera_y=camera_y-1*scale_factor 
		end
	end
	if btn(1) then 
		if camera_y+136/2+1*scale_factor
					<map_h/scale_factor then
			camera_y=camera_y+1*scale_factor
		end
	end




	if btn(2) then
	 if camera_x+240/2-1*scale_factor>0 then
			camera_x=camera_x-1*scale_factor 
		end
	end
	if btn(3) then
	 if camera_x+240/2+1*scale_factor
					<map_w/scale_factor then
			camera_x=camera_x+1*scale_factor 
		end
	end
	if btnp(4) then
		zoom_animation_flag=true
		t2=0
		if scale_factor>1 then
			scale_factor=scale_factor-1
			updateCameraPos(true)
		else
			if scale_factor>=0.7 then
				scale_factor=scale_factor-0.1
				camera_x =	camera_x+
															camera_x*(0.13)
															+(240/2)*(0.13)										
				camera_y = camera_y+
															camera_y*(0.13)
															+(136/2)*(0.13)
			end
		end
		
	end
	if btnp(5) then
		zoom_animation_flag=true
		t2=0
		if scale_factor<1 then
			scale_factor=scale_factor+0.1
			
			camera_x =	camera_x-
															camera_x*(0.13)
															-(240/2)*(0.13)										
				camera_y = camera_y-
															camera_y*(0.13)
															-(136/2)*(0.13)
		else 
			if scale_factor<8 then
				scale_factor=scale_factor+1
				updateCameraPos(false)
			end
		end
	end
	
	if btnp(6) then
		show_goal=not show_goal
		camera_x,camera_y=
			old_camera_x,old_camera_y
		scale_factor=old_scale_factor
	end
	
	if btnp(7) then
		checkGoal()
	end
	
	updateRenderBounds()
	
	if show_goal==false then
		old_camera_x, old_camera_y=
			camera_x, 
			camera_y
	
		old_scale_factor=scale_factor
		cls(0)
		map(0,0,240,136)
		if scale_factor==1 then
			print()
		end
		if win_flag==true then
			print('Score: ' .. score, 10, 20,12)	
		end
		print(camera_x, 10, 30)
		print('Zoom= ' .. scale_factor,
								10,10,12)
		print(camera_y, 10, 40)
		clip(8,8,224,120)
		drawStars()
		drawPlanets()
		--drawTelescope()
		zoomAnimation()
		--timeLimit()
		clip(minimap_x,minimap_y,
							240/minimap_scale,
							136/minimap_scale)
		cls(15)
		drawMinimap(minimap_x,minimap_y)
		clip(8,8,224,120)
	else
		scale_factor=5		
		camera_x, camera_y=100,70
		cls(0)
		drawStars()
		drawGoalPlanet(120,68)
	end
	--print(t2, 10,50)
	t=t+1/60
	t2=t2+1/60
end
