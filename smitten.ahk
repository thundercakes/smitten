#MaxThreadsPerHotkey 2
#SingleInstance force

#include %A_ScriptDir%
#Include speech.ahk

whitelist := []
commands := []
dictionary := {}

Loop, read, commands.csv
{
    LineNumber = %A_Index%
    Loop, parse, A_LoopReadLine, CSV
    {
		global whitelist
		global commands
		
		if(mod(A_Index,2) = 0)
			commands.Insert(A_LoopField)
		else
			whitelist.Insert(A_LoopField)
    }
}

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