--主入口函数。从这里开始lua逻辑
function Main()		
	GameObject = UnityEngine.GameObject
	Transform = UnityEngine.Transform
	RectTransform = UnityEngine.RectTransform
	ParticSystem = UnityEngine.ParticSystem
	SceneManagement = UnityEngine.SceneManagement
	Input = UnityEngine.Input
	KeyCode = UnityEngine.KeyCode
	Time = UnityEngine.Time
	Camera = UnityEngine.Camera
	AudioSource = UnityEngine.AudioSource
	Resources = UnityEngine.Resources
	Color = UnityEngine.Color
	www = UnityEngine.www
	Image = UnityEngine.UI.Image

	--UnityUtil = UnityUtil.New()
				
	print("logic start")	 		
end

--场景切换通知
function OnLevelWasLoaded(level)
	collectgarbage("collect")
	Time.timeSinceLevelLoad = 0
end

function OnApplicationQuit()
end
