using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class Main : MonoBehaviour
{
    LuaState luaState;
    void Awake()
    {
    }
    // Start is called before the first frame update
    void Start()
    {
        gameObject.AddComponent<LuaClient>();
        luaState = LuaClient.GetMainState();

        luaState.DoFile("GameMode.lua");
        luaState.DoFile("PlayerController.lua");
        //luaState.DoFile("BlockConfig.lua");
        luaState.DoFile("BlockController.lua");
        luaState.DoFile("BlockRenderer.lua");
        luaState.DoFile("HUD.lua");

        CallFunc("GameMode.Start");
        CallFunc("PlayerController.Start");
        CallFunc("BlockController.Start");
        CallFunc("BlockRenderer.Start");
        CallFunc("HUD.Start");
    }

    // Update is called once per frame
    void Update()
    {
        CallFunc("GameMode.Update");
        CallFunc("PlayerController.Update");
        CallFunc("BlockController.Update");
        CallFunc("BlockRenderer.Update");
        CallFunc("HUD.Update");
    }

    public void CallFunc(string func)
    {
        LuaFunction luaFunc = luaState.GetFunction(func);
        luaFunc.Call();
        luaFunc.Dispose();
        luaFunc = null;
    }
}
