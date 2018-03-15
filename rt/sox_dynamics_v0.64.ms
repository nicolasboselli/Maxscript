--만든이 : 이상원

-- 메모 $.params.btnPickPos.enabled = false

SoxLiveCrawlerCrossCa = attributes SoxLiveCrawlerCross
(
	parameters main rollout:params
	(
		vPairNodeIndex type:#integer animatable:false -- 노드로 기억시키면  possible dependency loop 발생하므로 상대 노드 handle 번호를 기억시킴
	)
		
	rollout params "Live Crawler"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		
		on btnSelectPairObject pressed do
		(
			try (select (maxOps.getNodeByHandle vPairNodeIndex)) catch ()
		)
	)
)

SoxLiveCrawlerBoxCa = attributes SoxLiveCrawlerBox
(
	parameters main rollout:params
	(
		vPairNode type:#node
		vGroundNode type:#node ui:pickGroundObj
	)
		
	rollout params "Live Crawler"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		group "Ground Object"
		(pickButton pickGroundObj "Pick Ground" width:150 autoDisplay:on)
		
		on pickGroundObj picked obj do
		(
			vPairNode.transform.controller.SetNode "Ground" obj
			vPairNode.transform.controller.Update()
		)
		
		on btnSelectPairObject pressed do
		(
			try (select vPairNode) catch ()
		)
	)
)

SoxHDTrackerUICa = attributes SoxHDTrackerUI
(
	parameters main rollout:params
	(
		vExecute type:#string
		vRangeOption type:#integer default:1 ui:radioRangeOption animatable:false
		vActionOption type:#integer default:1 ui:radioActionOption animatable:false
		vDelayThreshold type:#float default:0.001
		vTimeFrom type:#integer default:0 ui:spnTimeFrom animatable:false
		vTimeTo type:#integer default:100 ui:spnTimeTo animatable:false
		vPairNode type:#node
	)
		
	rollout params "HD. Tracker"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		
		group "Option" (
		radiobuttons radioActionOption "Action Type" labels:#("Drag", "Delay") default:1 align:#left columns:2 offset:[0, -4]
		spinner spnDelayThreshold "Delay Threshold" range:[0.0, 1, 0.001] type:#float scale:0.0001 align:#left
		radiobuttons radioRangeOption "Time Range Option" labels:#("Slider Time", "Custom") default:1 align:#left columns:2 offset:[0, 4]
		spinner spnTimeFrom "From" range:[-99999, 99999, 0] type:#integer width:80 offset:[-8, 0] across:2
		spinner spnTimeTo "To" range:[-99999, 99999, 100] type:#integer width:70 offset:[-2, 0]
		)
		button btnRefresh "Refresh" width:150
		
		on btnSelectPairObject pressed do
		(
			try (select vPairNode) catch ()
		)
		
		on btnRefresh pressed do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on radioActionOption changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnDelayThreshold changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on radioRangeOption changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnTimeFrom changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnTimeTo changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
	)
)

SoxHDTrackerCrossUICa = attributes SoxHDTrackerCrossUI
(
	parameters main rollout:params
	(
		vPairNodeIndex type:#integer animatable:false -- 노드로 기억시키면  possible dependency loop 발생하므로 상대 노드 handle 번호를 기억시킴
	)
		
	rollout params "HD. Tracker"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		
		on btnSelectPairObject pressed do
		(
			try (select (maxOps.getNodeByHandle vPairNodeIndex)) catch ()
		)
	)
)


SoxRealtimeSpringCA = attributes SoxRealtimeSpring  -- 스프링 십자 오브젝트용 UI 파라미터
(
	parameters main rollout:params
		(
			Tension type:#float ui:spnTension default:0.5
			Damping type:#float ui:spnDamping default:0.2
			vPairNode type:#node
		)

	rollout params "Live Spring"
		(
			button btnSelectPairObject "Select Pair OBJ" width:150
			spinner spnTension "Tension" type:#float scale:0.01 range:[0.0, 1.0, 0.5]
			spinner spnDamping "Damping" type:#float scale:0.01 range:[0.0, 1.0, 0.2]
			
			on btnSelectPairObject pressed do
			(
				try (select vPairNode) catch ()
			)
		)
)

SoxRealtimeSpringUICon = attributes SoxRealtimeSpringUICon -- 스프링 박스 오브젝트용 UI
(
	parameters main rollout:params
	(
		vPairNodeIndex type:#integer animatable:false -- 노드로 기억시키면  possible dependency loop 발생하므로 상대 노드 handle 번호를 기억시킴
	)
	
	rollout params "Live Spring"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		
		on btnSelectPairObject pressed do
		(
			try (select (maxOps.getNodeByHandle vPairNodeIndex)) catch ()
		)
	)
)

SoxRealtimeSpringCACon = attributes SoxRealtimeSpringCon -- 스프링 박스 오브젝트 컨트롤러용 파라미터
(
	parameters main
		(
			vPos type:#point3 default:[0, 0, 0] animatable:false
			vVec type:#point3 default:[0, 0, 0] animatable:false
			vTime type:#float default:0.0 animatable:false
		)
)

SoxTrackerCa = attributes SoxTracker
(
	parameters main
		(
			vPos type:#point3 default:[0, 0, 0] animatable:false
			vDist type:#float default:20.0
			vPairNode type:#node
			initPos type:#point3 default:[0, 0, 0] animatable:false
			initOnOff type:#boolean animatable:false
		)
)

SoxTrackerUiCa = attributes SoxTrackerUi
(
	parameters main rollout:params
	(
		Dist type:#float ui:spnDist default:20.0
-- 		pairNode type:#node
		initOnOff type:#boolean ui:chkbtnOnOff animatable:false
	)
	
	rollout params "Live Tracker"
		(
			local scriptTracker = "try (
if (normTime 0 == currentTime and this.SoxTracker.initOnOff == true)
then (tPos = (this.SoxTracker.initPos + this.SoxTracker.vPairNode.transform.pos);this.SoxTracker.vDist = length this.SoxTracker.initPos)
else (tPos = ((normalize (this.SoxTracker.vPos - TP.transform.pos)) * this.SoxTracker.vDist) + TP.transform.pos)
this.SoxTracker.vPos = tPos
tPos
) catch this.vPos"
			
			button btnSelectPairObject "Select Pair OBJ" width:150
			spinner spnDist "Distance" type:#float scale:0.1 range:[0.0, 999999.0, 20.0]
			pickbutton btnPickPos "Pick Position OBJ"
			group "Initial Position"
			(
				button btnSave "Save" width:60 toolTip:"Save current position as Initial Position" across:2
				checkbutton chkbtnOnOff "Activate" width:60 tooltip:"Activate Initial Position at Animation start"
			)
			
			on btnSelectPairObject pressed do
			(
				try (select $.pos.controller.vPairNode) catch ()
			)
			
			on btnSave pressed do
			(
				$.position.controller.initPos = $.pos - $.position.controller.vPairNode.transform.pos -- 페어 노드로부터 상대적인 위치로 기억하도록 한다.
			)
			
			on chkbtnOnOff changed var do
			(
				$.position.controller.initOnOff = var -- UI상의 버튼 상태를 애니메이션 컨트롤러의 OnOff 변수에 동기화 해준다.
				-- 포지션 스크립트 컨트롤러에서는 자기 자신을 지정하면 디펜던시 루프가 걸리므로 this 라는 자기 자신을 의미하는 예약어에 의해 자기 자신 컨트롤러의 하위에 저장된 커스텀 파라미터에만 접근이 가능하기 때문
				if var then $.params.btnPickPos.enabled = false else $.params.btnPickPos.enabled = true
			)
			
			on spnDist changed var do
			(
				$.pos.controller.script  = scriptTracker
				
				$.position.controller.vDist = var -- Dist 값 동기화
				
			)
			
			on params open do
			(
				$.position.controller.vDist = Dist -- Dist 값 동기화
				if initOnOff then $.params.btnPickPos.enabled = false else $.params.btnPickPos.enabled = true
			)
			
			on btnPickPos picked obj do
			(
				$.pos.controller.SoxTracker.vPos = obj.transform.pos
				tDist = distance $.position.controller.vPairNode.transform.pos obj.transform.pos
				$.baseobject.Dist = tDist
				$.pos.controller.SoxTracker.vDist = tDist
				$.pos.controller.script  = scriptTracker
			)
		)
)

SoxDynamicsWheelCrossUiCa = attributes SoxDynamicsWheelCrossUi
(
	parameters main rollout:params
	(
		vPairNodeIndex type:#integer animatable:false -- 노드로 기억시키면  possible dependency loop 발생하므로 상대 노드 handle 번호를 기억시킴
	)
		
	rollout params "HD. Wheel"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		
		on btnSelectPairObject pressed do
		(
			try (select (maxOps.getNodeByHandle vPairNodeIndex)) catch ()
		)
	)
)

SoxDynamicsWheelUiCa = attributes SoxDynamicsWheelUi
(
	parameters main rollout:params
	(
		vRangeOption type:#integer default:1 ui:radioRangeOption animatable:false
		vTimeFrom type:#integer default:0 ui:spnTimeFrom animatable:false
		vTimeTo type:#integer default:100 ui:spnTimeTo animatable:false
		vNode type:#node
		vPairNode  type:#node
		vRadius1 type:#float default:8.0 ui:spnRadius1
		vRadius2 type:#float default:10.0 ui:spnRadius2
	)
	
	rollout params "HD. Wheel"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		
		spinner spnRadius1 "Radius 1:" range:[0.001, 99999.0, 8.0] type:#float
		spinner spnRadius2 "Radius 2:" range:[0.001, 99999.0, 8.0] type:#float
		
		radiobuttons radioRangeOption "Time Range Option" labels:#("Slider Time", "Custom") default:1
		spinner spnTimeFrom "From" range:[-99999, 99999, 0] type:#integer width:80 offset:[-8, 0] across:2
		spinner spnTimeTo "To" range:[-99999, 99999, 100] type:#integer width:70 offset:[-2, 0]
		button btnRefresh "Refresh" width:150
		
		on btnSelectPairObject pressed do
		(
			try (select vPairNode) catch ()
		)
		
		on btnRefresh pressed do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on radioRangeOption changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnRadius1 changed var do
		(
			$.radius1 = var
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnRadius2 changed var do
		(
			$.radius2 = var
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnTimeFrom changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnTimeTo changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
	)
		
)

SoxDynamicsSusCrossUiCa = attributes SoxDynamicsSusCrossUi
(
	parameters main rollout:params
	(
		vPairNodeIndex type:#integer animatable:false -- 노드로 기억시키면  possible dependency loop 발생하므로 상대 노드 handle 번호를 기억시킴
	)
		
	rollout params "HD. Suspension"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		
		on btnSelectPairObject pressed do
		(
			try (select (maxOps.getNodeByHandle vPairNodeIndex)) catch ()
		)
	)
)

SoxDynamicsSusUiCa = attributes SoxDynamicsSusUi
(
	parameters main rollout:params
	(
		vRangeOption type:#integer default:1 ui:radioRangeOption animatable:false
		vTimeFrom type:#integer default:0 ui:spnTimeFrom animatable:false
		vTimeTo type:#integer default:100 ui:spnTimeTo animatable:false
		vNode type:#node
		vPairNode  type:#node
		
		vHeight type:#float default:8.0 ui:spnHeight
		vTension type:#float default:0.5 ui:spnTension
		vDamping type:#float default:0.7 ui:spnDamping
		vGravity type:#float default:-0.2 ui:spnGravity
		vFlying type:#boolean default:true ui:chkFlying
	)
	
	rollout params "HD. Suspension"
	(
		button btnSelectPairObject "Select Pair OBJ" width:150
		
		spinner spnHeight "Height:" range:[0.001, 99999.0, 10.0] type:#float
		spinner spnTension "Tension:" range:[0.0, 5.0, 0.5] type:#float
		spinner spnDamping "Damping:" range:[0.0, 0.99999, 0.7] type:#float
		spinner spnGravity "Gravity:" range:[-99999.0, 0.0, -0.2] type:#float
		
		radiobuttons radioRangeOption "Time Range Option" labels:#("Slider Time", "Custom") default:1
		spinner spnTimeFrom "From" range:[-99999, 99999, 0] type:#integer width:80 offset:[-8, 0] across:2
		spinner spnTimeTo "To" range:[-99999, 99999, 100] type:#integer width:70 offset:[-2, 0]
		checkbutton chkFlying "Flying" width:150 enabled:false
		
		button btnRefresh "Refresh" width:150
		
		on btnSelectPairObject pressed do
		(
			try (select vPairNode) catch ()
		)
		
		on btnRefresh pressed do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on radioRangeOption changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnHeight changed var do
		(
			$.height = var
			animate off ($.radius1 = var * 0.15;$.radius2 = var * 0.15)
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnTension changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnDamping changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnGravity changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnTimeFrom changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
		
		on spnTimeTo changed var do
		(
			$.vPairNode.transform = $.vPairNode.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼를 제자리 이동해서 강제로 이벤트를 발생시킨다.
		)
	)
		
)


try (destroydialog SOX_RealtimeSpring) catch()

rollout SOX_RealtimeSpring "SOX Dynamics v0.64" width:180
(
	button AboutButton "About" width:80 offset:[-5,0] height:14 across:2
	button site "Site" width:80 offset:[5,0] height:14
	progressBar dummyBar1 width:170 height:4 offset:[-8,0]
	
	button btnCreateSpring "Live Spring" width:80 offset:[-5,-2] across:2
	button btnCreateCrawler "Live Crawler" width:80 offset:[5, -2]
	
	button btnCreateTracker "Live Tracker" width:80 offset:[-5,0] across:2
	spinner spnTrackDist "Dist." range:[0.0, 999999.0, 20.0] width:80 offset:[-4,2]
	
	button btnCreateHDTracker "HD. Tracker" width:80 offset:[-5,0] across:2
	spinner spnHDTrackDist "Dist." range:[0.0, 999999.0, 20.0] width:80 offset:[-4,2]
	
	button btnCreateHDWheel "HD. Wheel" width:80 offset:[-5,0] across:2
	spinner spnHDWheelRad "Rad." range:[0.0001, 999999.0, 10.0] width:80 offset:[-4,2]
	
	button btnCreateHDSus "HD. Sus." width:80 offset:[-5,0] toolTip:"HD. Suspension with Gravity" across:2
	spinner spnHDSusHeight "Height" range:[0.0001, 999999.0, 10.0] width:88 offset:[-4,2]
	
	on btnCreateHDSus pressed do
	(
		if selection.count == 0 do return ()
		tObj = selection as array
		for o = 1 to tObj.count do
		(
			-- Wheel에 로테이션 트랜스폼 키를 구워넣을 때마다 중복해서 콜백이 발생하지 않도록 이동 감시와 콜백 발생은 따로 포인트 헬퍼를 통해서 진행함
			tPointCross = Point pos:tObj[o].transform.pos isSelected:off Box:off cross:on axistripod:off centermarker:off size:((distance tObj[o].min tObj[o].max) * 0.6)
			tPointCross.wirecolor = color 216 255 0
			tPointCross.pos.controller = Position_Constraint ()
			tPointCross.pos.controller.appendTarget tObj[o] 50.0
			
			tSus = Helix radius1:(spnHDSusHeight.value * 0.15) radius2:(spnHDSusHeight.value * 0.15) height:(spnHDSusHeight.value * -1) turns:8 bias:0 direction:0 pos:tObj[o].transform.pos isSelected:on
			tSus.wirecolor = color 216 255 0
			tSus.pos.controller = Position_XYZ ()
			tSus.baseObject.height.controller = bezier_float () -- 스프링 애니메이션용 height 값은 디폴트 컨트롤러가 지정되어있지 않은 상태로 helix가 생성된다.
			tSus.pos = (at time 0 tObj[o].transform.pos) + [0, 0, spnHDSusHeight.value]
			
			tCrossHandle = tPointCross.inode.handle
			tSusHandle = tSus.inode.handle
			
			CustAttributes.add tPointCross.baseObject SoxDynamicsSusCrossUiCa
			tPointCross.baseObject.vPairNodeIndex = tSus.inode.handle
			CustAttributes.add tSus.baseObject SoxDynamicsSusUiCa
			tSus.baseObject.vPairNode = tPointCross
			tSus.baseObject.vNode = tObj[o]
			tSus.baseObject.vFlying.controller = boolean_float()
			
			-- 콜백이 실행되면서 휠의 Position Constraint 부모를 강제로 확인차 끊어줘야한다. 안그러면 콜백에 의해 또 콜백이 발생하는 뻥튀기 가능성이 생긴다.
			-- 콜백에 의해 키가 구워지는 동안에는 대상 오브젝트에 영향을 주는 요소가 없다는 가정으로 시작하는게 바람직함
			tStringDo = "(if mouse.buttonStates[1] == false do (\ntNodeSus = maxOps.getNodeByHandle " + (tSusHandle as string)
			tStringDo += "\ntNodeCross = maxOps.getNodeByHandle " + (tCrossHandle as string)
			tStringDo += "\ndisableSceneRedraw()
	local tFrom
	local tTo
	
	tNodeSus.parent = undefined
	
	if tNodeSus.vRangeOption == 1 then (tFrom = ((normTime 0) as integer) / ticksPerFrame;tTo = ((normTime 1) as integer) / ticksPerFrame)
	else (tFrom = tNodeSus.vTimeFrom;tTo = tNodeSus.vTimeTo)

	if (tTo - tFrom) <= 0 do (tTo = tFrom + 1)

	deleteKeys tNodeSus.transform.controller.position.controller.keys #allKeys
	deleteKeys tNodeSus.baseObject.height.controller.keys #allKeys
	tPos = at time tFrom tNodeCross.transform.position
	tPos.z += tNodeSus.baseObject.vHeight
	animate on (
		at time tFrom (tNodeSus.transform.controller.position = tPos)
		at time tFrom (tNodeSus.baseObject.height = tNodeSus.baseObject.vHeight * -1)
	)
	
	local beforeForceZ = 0.0
	local beforePosZ = (at time tFrom tNodeCross.transform.position.z) + tNodeSus.baseObject.vHeight
	for o = (tFrom + 1) to tTo do
	(
		local tensionForce = ((at time (o - 1) (tNodeSus.transform.position.z - tNodeSus.baseObject.vHeight)) - (at time o tNodeCross.transform.position.z)) * -1 -- 스프링 탄성
		tensionForce = amax 0.0 tensionForce -- 위로 상승하는 힘만 걸러내는 역할
		local newPosZ = (tensionForce * tNodeSus.baseObject.vTension) + beforePosZ + beforeForceZ + tNodeSus.baseObject.vGravity
		if newPosZ < (at time o tNodeCross.transform.position.z) do -- 서스펜션이 지면을 파고든다면 강제로 끌어올리고 올린 만큼 벡터를 더해줘야함
		(
			tKick = (at time o tNodeCross.transform.position.z) - newPosZ
			newPosZ += tKick
			tensionForce += tKick * tNodeSus.baseObject.vTension
		)
		
		local tPress = newPosZ - (at time o tNodeCross.transform.position.z)
		local finalHeight = (amin tPress tNodeSus.baseObject.vHeight) * -1
		
		animate on (
			at time o (tNodeSus.transform.controller.position = [tNodeCross.transform.pos.x, tNodeCross.transform.pos.y, newPosZ])
			at time o (tNodeSus.baseObject.height = finalHeight)
		)
		
		tDist = at time o (tNodeSus.transform.position.z - tNodeCross.transform.position.z)
		local stateFlying = if tDist > tNodeSus.baseObject.vHeight then true else false
		animate on (at time o tNodeSus.baseObject.vFlying = stateFlying)
		
		newDamping = amin tNodeSus.baseObject.vDamping (tNodeSus.baseObject.vDamping * (tensionForce / tNodeSus.baseObject.vHeight))
		-- 텐션이 있는 경우만 댐핑이 작동하도록 하기 위해서 스프링 높이값으로 노말라이즈 된 텐션 퍼센트를 곱해준다. 결국 텐션이 강할 수록 원래 댐핑 수치가 나타나게 되는 구조
		-- 하지만 벽을 뚫고 들어가는 등의 경우에는 텐션 포스가 스프링 높이를 훨씬 뛰어넘는 비정상적인 텐션 값이 나올 수 있으므로
		-- tensionForce / tHeight 의 연산이 1보다 큰 경우가 나올 수 있고 결과적으로 벽에서 Kick 되는 순간 직후에 비정상적으로 높은 Damping 값이 나오는 경우가 있다.
		-- 이런 예외상황의 보완책으로 어떤 경우에도 newDamping 값은 원래 tDamping 값보다 높게 나오지 않도록 안전장치를 설정함.

		beforeForceZ = (newPosZ - beforePosZ) * (1 - (amin 1.0 newDamping))
		beforePosZ = newPosZ
	)
		
	if tNodeSus.position.controller.keys[1].time != (tFrom as time) do (tNodeSus.position.controller.keys[1].selected = true;deleteKeys tNodeSus.position.controller.keys #selection)
	enableSceneRedraw()
))"
			tString = "when transform (maxOps.getNodeByHandle " + (tCrossHandle as string) + ") changes id:#SOXHDSus do " + tStringDo
			execute tString
			
-- 			print tString
			
			tPointCross.transform = tPointCross.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼에 제자리 움직임을 주어서 강제로 이벤트를 한번 발생시킨다.
		)
	)
	
	on btnCreateHDWheel pressed do
	(
		if selection.count == 0 do return ()
		tObj = selection as array
		for o = 1 to tObj.count do
		(
			-- Wheel에 로테이션 트랜스폼 키를 구워넣을 때마다 중복해서 콜백이 발생하지 않도록 이동 감시와 콜백 발생은 따로 포인트 헬퍼를 통해서 진행함
			tPointCross = Point pos:tObj[o].transform.pos isSelected:off Box:off cross:on axistripod:off centermarker:off size:((distance tObj[o].min tObj[o].max) * 0.8)
			tPointCross.wirecolor = color 28 149 177
			tPointCross.pos.controller = Position_Constraint ()
			tPointCross.pos.controller.appendTarget tObj[o] 50.0
			
			tStar = Star radius1:(spnHDWheelRad.value * 0.8) radius2:spnHDWheelRad.value fillet1:0 fillet2:0 numPoints:6 distort:0 pos:tObj[o].transform.pos isSelected:on
			tStar.wirecolor = color 28 149 177
			tStar.pos.controller = Position_Constraint ()
			tStar.pos.controller.appendTarget tObj[o] 50.0
			
			tCrossHandle = tPointCross.inode.handle
			tStarHandle = tStar.inode.handle
			
-- 			tPointBox.baseObject.vPairNode = tPointCross
-- 			tPointCross.baseObject.vPairNodeIndex = tPointBox.inode.handle
			
			CustAttributes.add tPointCross.baseObject SoxDynamicsWheelCrossUiCa
			tPointCross.baseObject.vPairNodeIndex = tStar.inode.handle
			CustAttributes.add tStar.baseObject SoxDynamicsWheelUiCa
			tStar.baseObject.vPairNode = tPointCross
			tStar.baseObject.vNode = tObj[o]
			
			-- 콜백이 실행되면서 휠의 Position Constraint 부모를 강제로 확인차 끊어줘야한다. 안그러면 콜백에 의해 또 콜백이 발생하는 뻥튀기 가능성이 생긴다.
			-- 콜백에 의해 키가 구워지는 동안에는 대상 오브젝트에 영향을 주는 요소가 없다는 가정으로 시작하는게 바람직함
			tStringDo = "(if mouse.buttonStates[1] == false do (try(\ntNodeStar = maxOps.getNodeByHandle " + (tStarHandle as string)
			tStringDo += "\ntNodeCross = maxOps.getNodeByHandle " + (tCrossHandle as string)
			tStringDo += "\ndisableSceneRedraw()
	local tFrom
	local tTo
	
	tNodeStar.parent = undefined
	try (tNodeStar.pos.controller.deleteTarget 1) catch ()
	
	if tNodeStar.vRangeOption == 1 then (tFrom = ((normTime 0) as integer) / ticksPerFrame;tTo = ((normTime 1) as integer) / ticksPerFrame)
	else (tFrom = tNodeStar.vTimeFrom;tTo = tNodeStar.vTimeTo)

	if (tTo - tFrom) <= 0 do (tTo = tFrom + 1)

	tRot = at time tFrom tNodeCross.transform.controller.rotation.controller.z_rotation
	deleteKeys tNodeStar.transform.controller.rotation.controller.z_rotation.keys #allKeys
	animate on (at time tFrom (tNodeStar.transform.controller.rotation.controller.z_rotation = tRot))
	for o = (tFrom + 1) to tTo do
	(
		tPosBefore = at time (o - 1) tNodeCross.transform.position
		tPosNow = at time o tNodeCross.transform.position
		tRot += radToDeg ((distance tPosBefore tPosNow) / (amax (amax (at time o tNodeStar.baseObject.vRadius1) (at time o tNodeStar.baseObject.vRadius2)) 0.00001)) -- Avoid divide by Zero
		animate on (at time o (tNodeStar.transform.controller.rotation.controller.z_rotation = tRot))
	)
	if tNodeStar.transform.controller.rotation.controller.z_rotation.keys[1].time != (tFrom as time) do (tNodeStar.transform.controller.rotation.controller.z_rotation.keys[1].selected = true;deleteKeys tNodeStar.transform.controller.rotation.controller.z_rotation.keys #selection)
	tNodeStar.pos.controller.appendTarget tNodeStar.baseObject.vNode 50.0
	enableSceneRedraw()
) catch ()))"
			tString = "when transform (maxOps.getNodeByHandle " + (tCrossHandle as string) + ") changes id:#SOXHDWheel do " + tStringDo
			execute tString
			
			tPointCross.transform = tPointCross.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼에 제자리 움직임을 주어서 강제로 이벤트를 한번 발생시킨다.
			select tStar
		)
	)

	on btnCreateHDTracker pressed do
	(
		if selection.count == 0 do return ()
		tObj = selection as array
		for o = 1 to tObj.count do
		(
			tPointCross = Point pos:tObj[o].transform.pos isSelected:off Box:off cross:on axistripod:off centermarker:off size:((distance tObj[o].min tObj[o].max) * 0.8)
			tPointCross.wirecolor = blue
			tPointCross.pos.controller = Position_Constraint ()
			tPointCross.pos.controller.appendTarget tObj[o] 50.0
			
			tPointBox = Point pos:tObj[o].transform.pos isSelected:off Box:on cross:off axistripod:off centermarker:off size:((distance tObj[o].min tObj[o].max) * 0.6)
			tPointBox.wirecolor = blue
			tPointBox.pos.controller = Position_XYZ () -- 디폴트 컨트롤러가 변경되어있을지도 모르므로 포지션 XYZ로 확인사살
			tPointBox.pos = (at time 0 tObj[o].transform.pos) + [spnHDTrackDist.value, 0, 0]
			
			tHandleCross = tPointCross.inode.handle -- execute로 실행될 스크립트 텍스트 스트링에 삽입될 ID 번호
			tHandleBox = tPointBox.inode.handle -- execute로 실행될 스크립트 텍스트 스트링에 삽입될 ID 번호
			
			CustAttributes.add tPointBox.baseobject SoxHDTrackerUICa
			tPointBox.baseObject.vPairNode = tPointCross
			
			CustAttributes.add tPointCross.baseobject SoxHDTrackerCrossUICa
			tPointCross.baseObject.vPairNodeIndex = tPointBox.inode.handle
			

			tStringDo = "(if mouse.buttonStates[1] == false do (try(\nlocal tNodeTP = maxOps.getNodeByHandle " + (tHandleCross as string)
			tStringDo += "\nlocal tNodeBox = maxOps.getNodeByHandle " + (tHandleBox as string)
			tStringDo += "\ndisableSceneRedraw()
	local tFrom
	local tTo
	tNodeBox.parent = undefined
	if tNodeBox.vRangeOption == 1 then (tFrom = ((normTime 0) as integer) / ticksPerFrame;tTo = ((normTime 1) as integer) / ticksPerFrame)
	else (tFrom = tNodeBox.vTimeFrom;tTo = tNodeBox.vTimeTo)
	if (tTo - tFrom) <= 0 do (tTo = tFrom + 1)
	
	case of
	(
		((tNodeBox.vActionOption) == 1):(
			local beforeVec = at time tFrom tNodeBox.transform.pos
			local tDist = distance beforeVec (at time tFrom tNodeTP.transform.pos)
			tPos = at time tFrom tNodeBox.transform.pos
			deleteKeys tNodeBox.position.controller.keys #allKeys
			tNodeBox.transform.controller.position = tPos
			animate on (at time tFrom (tNodeBox.transform.controller.position = tPos))
			for o = (tFrom + 1) to tTo do
			(
				tTPVec = at time o tNodeTP.transform.position
				tNewVec = ((normalize (beforeVec - tTPVec)) * tDist) + tTPVec
				animate on (at time o (tNodeBox.transform.controller.position = tNewVec))
				beforeVec = tNewVec
			)
		) -- case1 end
		((tNodeBox.vActionOption) == 2):(
				local tBeforeVec = at time tFrom tNodeTP.transform.pos
				for o = tFrom to tTo do
				(
					if tBeforeVec != (at time o tNodeTP.transform.pos) do (tFrom = o - 1; exit)
				)
				
				if tFrom >= tTo do tFrom = tTo - 1
				
				tPos = at time tFrom tNodeBox.transform.pos
				deleteKeys tNodeBox.position.controller.keys #allKeys
				tNodeBox.transform.controller.position = tPos
				animate on (at time tFrom tNodeBox.pos = ((at time tFrom tNodeTP.transform.pos) * 2) - (at time (tFrom + 1) tNodeTP.transform.pos))
				tBeforeVec = at time tFrom tNodeTP.transform.pos
				for o = (tFrom + 1) to tTo do
				(
					animate on (
						if (distance (at time o tNodeTP.transform.pos) (at time (o - 1) tNodeTP.transform.pos)) >= tNodeBox.vDelayThreshold then -- 현재 프레임 위치가 이전 위치와 다르면, 즉 변화가 있으면
						(
							at time o (tNodeBox.pos = (at time (o - 1) tNodeTP.transform.pos)) -- 한 프레임 전의 tNodeTP 위치를 적용함
							tBeforeVec = at time (o - 1) tNodeTP.transform.pos -- 전진했으므로 다음 프레임 계산을 위해 tBeforeVec을 현재 위치로 갱신
						)
						else -- 위치가 같거나 거의 비슷해서 변화가 없으면
						(
							at time o (tNodeBox.pos = tBeforeVec)
						)
					)
				)
		) -- case2 end
	) -- case end
	if tNodeBox.position.controller.keys[1].time != (tFrom as time) do (tNodeBox.position.controller.keys[1].selected = true;deleteKeys tNodeBox.position.controller.keys #selection)
	enableSceneRedraw()
	) catch ()))"
			tString = "when transform (maxOps.getNodeByHandle " + (tHandleCross as string) + ") changes id:#SOXHDTracker do " + tStringDo
			execute tString
			
			tPointCross.transform = tPointCross.transform -- 이벤트 핸들러의 Master 역할을 하는 포인트 헬퍼에 제자리 움직임을 주어서 강제로 이벤트를 한번 발생시킨다.
			select tPointBox
		)
	)
	
	on btnCreateTracker pressed do
	(
		if selection.count == 0 do return ()
		tObj = selection as array
		for o = 1 to tObj.count do
		(
			tPointCross = Point pos:tObj[o].transform.pos isSelected:off Box:off cross:on axistripod:off centermarker:off size:((distance tObj[o].min tObj[o].max) * 0.8)
			tPointCross.pos += [spnTrackDist.value, 0, 0]
			tPointCross.wirecolor = red
			tPointCross.pos.controller = position_script ()
			
			CustAttributes.add tPointCross.pos.controller SoxTrackerCa
			CustAttributes.add tPointCross.baseobject SoxTrackerUiCa
			
			tPointCross.pos.controller.SoxTracker.vPos = tPointCross.pos
			tPointCross.pos.controller.AddNode "TP" tObj[o]
			
			local scriptTracker = "try (
if (normTime 0 == currentTime and this.SoxTracker.initOnOff == true)
then (tPos = (this.SoxTracker.initPos + this.SoxTracker.vPairNode.transform.pos);this.SoxTracker.vDist = length this.SoxTracker.initPos)
else (tPos = ((normalize (this.SoxTracker.vPos - TP.transform.pos)) * this.SoxTracker.vDist) + TP.transform.pos)
this.SoxTracker.vPos = tPos
tPos
) catch this.vPos"
			tPointCross.pos.controller.script  = scriptTracker
			tPointCross.baseobject.Dist = spnTrackDist.value
-- 			tPointCross.baseobject.pairNode = tObj[o] -- 짝꿍 오브젝트를 기억하는 파라미터
			tPointCross.position.controller.vPairNode = tObj[o] -- 짝꿍 오브젝트를 컨트롤러에도 기억하는 파라미터
			
			select tPointCross
		)
	)
	
	on btnCreateCrawler pressed do
	(
		if selection.count == 0 do return ()
		
		local scriptSpring = "try(
	tRay = ray PBox.transform.pos (normalize (((transMatrix [0, 0, -1]) * PBox.transform).pos - PBox.transform.pos))
	tIntersect = intersectRay Ground tRay
	tPos = tIntersect.position
	tNorm = tIntersect.dir
) catch (
	try (
		tVecA = [-PBox.dir.x, -PBox.dir.y, -PBox.dir.z]
		tArc = acos(dot tVecA [0, 0, -1])
		tDist = (PBox.pos.z / sin (90.0 - tArc)) -- 대각선 길이
		tPos = (tVecA * tDist) + PBox.pos
		tNorm = [0, 0, 1]
		) catch (tPos = [0, 0, 0];tNorm = [0, 0, 1])
	)
pUp = [0, 1, 0]
pAt = tNorm + tPos
pEye = tPos
zaxis = normalize (pAt - pEye)
xaxis = normalize (cross pUp zaxis)
yaxis = cross zaxis xaxis
inverse (matrix3 [xaxis.x, yaxis.x, zaxis.x] [xaxis.y, yaxis.y, zaxis.y] [xaxis.z, yaxis.z, zaxis.z] [((dot xaxis pEye) * -1), ((dot yaxis pEye) * -1), ((dot zaxis pEye) * -1)])"
		
		tObj = selection as array
		for o = 1 to tObj.count do
		(
			tHelperSize = distance tObj[o].min tObj[o].max
			tPointCross = Point pos:tObj[o].transform.pos isSelected:off Box:off cross:on axistripod:off centermarker:off size:(tHelperSize * 0.1)
			tPointCross.wirecolor = color 245 0 255 -- pink
			tPointCross.transform.controller = transform_script ()
			
			tPointBox = Point pos:tObj[o].transform.pos isSelected:off Box:on cross:off axistripod:off centermarker:off size:(tHelperSize * 0.1)
			tPointBox.wirecolor = color 245 0 255 -- pink
			tPointBox.pos += [0, 0, (tObj[o].max.z + (tHelperSize * 0.2))]
			
			tPointCross.transform.controller.AddNode "PBox" tPointBox
			tPointCross.transform.controller.AddNode "Ground" tObj[o]
			tPointCross.transform.controller.script  = scriptSpring
				
			CustAttributes.add tPointCross.baseObject SoxLiveCrawlerCrossCa
			CustAttributes.add tPointBox.baseObject SoxLiveCrawlerBoxCa
			tPointBox.baseObject.vPairNode = tPointCross
			tPointBox.baseObject.vGroundNode = tObj[o]
			tPointCross.baseObject.vPairNodeIndex = tPointBox.inode.handle
			
			select tPointBox
		)
	)
	
	on btnCreateSpring pressed do
	(
		if selection.count == 0 do return ()
		
		local scriptSpring = "try (
tTime = timeStamp () / 30
diff = abs (tTime - this.vTime)
if diff >= 1 then (
this.vTime = tTime

tVec = (P.transform.pos - this.vPos) * PCross.Tension

tPos = this.vPos + tVec + this.vVec
this.vPos = tPos
this.vVec = (tVec + this.vVec) * (1.0 - PCross.Damping)

tPos
)
else this.vPos
) catch this.vPos"
		
		tObj = selection as array
		for o = 1 to tObj.count do
		(
			tPointCross = Point pos:tObj[o].transform.pos isSelected:off Box:off cross:on axistripod:off centermarker:off size:((distance tObj[o].min tObj[o].max) * 0.8)
			tPointCross.wirecolor = yellow
			tPointCross.pos.controller = Position_Constraint ()
			tPointCross.pos.controller.appendTarget tObj[o] 50.0
			
			CustAttributes.add tPointCross SoxRealtimeSpringCA
			
			tPointBox = Point pos:tObj[o].transform.pos isSelected:off Box:on cross:off axistripod:off centermarker:off size:((distance tObj[o].min tObj[o].max) * 0.6)
			tPointBox.wirecolor = yellow
			tPointBox.pos.controller = position_script ()

			CustAttributes.add tPointBox.pos.controller SoxRealtimeSpringCACon
			CustAttributes.add tPointBox.baseObject SoxRealtimeSpringUICon
			tPointBox.pos.controller.vPos = tObj[o].transform.pos
			tPointBox.pos.controller.AddNode "P" tObj[o]
			tPointBox.pos.controller.AddNode "PCross" tPointCross
			tPointBox.pos.controller.script  = scriptSpring
			
			tPointCross.baseObject.vPairNode = tPointBox -- 서로 상대방 노드를 기억시킨다.
			tPointBox.baseObject.vPairNodeIndex = tPointCross.inode.handle -- 서로 상대방 노드를 기억시킨다.
			
		)
	)
	
	on SOX_RealtimeSpring close do
	(

	)
	
	on SOX_RealtimeSpring open do
	(

	)
	
	on AboutButton pressed do
	(
		aboutText ="만든이 : 이상원

이 툴은 배포와 수정이 자유롭습니다.
하지만 상업적인 목적으로 판매할 수 없으며 배포할 때는 반드시 원작자를 표기해야 합니다.

사용법 :
움직이는 오브젝트를 선택한 상태에서 Live Spring 버튼을 클릭하면 노란 색의 십자 헬퍼와 박스 헬퍼가 생성됩니다. 십자 헬퍼는 텐션과 댐핑 값을 조절하는 역할이고 박스 헬퍼는 실제로 스프링이 적용되는 헬퍼입니다.

지면 오브젝트가 선택된 상태에서Live Crawler 버튼을 누르면 지면을 자동으로 따라가는 포인트 헬퍼가 생성됩니다. 박스 형태의 Crawler를 마우스로 움직여보세요.

Live Tracker 버튼은 특정 거리를 언제나 유지하는 빨간 색의 포인트 헬퍼를 생성합니다.

HD. Tracker 버튼은 특정 거리를 언제나 유지하는 빨간 색의 포인트 헬퍼를 생성하는데 History Dependant 방식으로 작동됩니다.

HD. Wheel 버튼은 자동으로 바퀴 회전을 계산해주는 오브젝트를 생성합니다. 생성된 Star 오브젝트의 Z축 회전을 원하는 곳에 Wire Parameter로 연결해보세요.
Star 오브젝트의 Radius1, Radius2 값은 자동으로 더 큰 값을 인식합니다. 또한 Radius 크기를 애니메이션 해도 됩니다(굴러가면서 바퀴가 점점 커지는 등).

모든 다이나믹스 오브젝트들은 다른 오브젝트의 자식으로 링크하면 안됩니다(Live Crawler 제외).

자세한 사용법은 Site 버튼을 클릭해서 열리는 홈페이지의 동영상 튜터리얼을 참고하세요"
		messagebox aboutText
	)

	on site pressed do
	(
		shellLaunch "http://cafe.naver.com/pinksox/3470" ""
	)
)

createDialog SOX_RealtimeSpring style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) lockWidth:true
