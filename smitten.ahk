#MaxThreadsPerHotkey 2
#SingleInstance force

#include %A_ScriptDir%
#Include speech.ahk

;BEGIN EDITING ZONE
whitelist := ["attack","behind","jungle","careful","defend","laugh","joke","missing","gank","help","incoming","ward","retreat","on it","buff","take","re","okay","b","mana","thanks","wait","cancel","nice","welcome","group","stay","trap","ultimate","way"]

commands := ["VAA","VVVB","VBJJ","VCC","VDD","VEL","VEJ","VFF","VGG","VHH","VII","VQN","VRR","VSO","VSBB","VSBT","VTT","VVA","VVB","VVM","VVT","VVW","VVX","VVGN","VVGW","VVVG","VVVS","VVVT","VVVR","VVVE"]
;END EDITING ZONE

dictionary := {}
Loop % whitelist.maxIndex()
	dictionary[whitelist[A_Index]] := commands[A_Index]

class CustomSpeech extends SpeechRecognizer
{
    OnRecognize(Text)
    {
		global dictionary
		lookup := dictionary[Text]
		TrayTip, Speech Recognition, You said: %Text% -- %lookup%
		BlockInput, On
		SetKeyDelay, 30
		Send %lookup%
		BlockInput, Off
    }
}

Loop {
	IfWinActive, Smite
	{
		KeyWait, LShift, D
		SoundBeep
		
		s := new CustomSpeech
		s.Recognize(whitelist)
		
		KeyWait, LShift, D T4
		SoundBeep, 750, 500
		
		s.__Delete()
		s := ""
	}
}