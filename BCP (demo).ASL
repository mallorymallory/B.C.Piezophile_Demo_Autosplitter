state("B.C. Piezophile")
{
    int lvlstart : "UnityPlayer.dll", 0x1A5FF3C;
    int flags : "UnityPlayer.dll", 0x01A98ED8, 0x8D0;
}  

startup{    
    refreshRate = 30;
}

init
{    
    vars.logs = "bcasl_logs_v1.txt";
    vars.tempvar = false;

    vars.Setup = false;
    vars.Split = false;
    vars.Reset = false;
    vars.IsLoading = false;
}   

update
{
    if(old.lvlstart != current.lvlstart){
        File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + ":startvar:" + current.lvlstart.ToString() + '\n');
        if((current.lvlstart >= 177844000 && current.lvlstart < 177845000)||current.lvlstart >= 177877000 && current.lvlstart < 177878000){
            vars.Setup = true;
            if(vars.IsLoading){
                vars.IsLoading = false;
                vars.Reset = true;
            }
            

        }
    }

    if (vars.Setup){
        if(old.flags != current.flags){
            vars.Split = true;
            File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + ":flagvar:" + current.flags.ToString() + '\n');
        }
        if(!(current.lvlstart >= 177844000 && current.lvlstart < 177845000) && !(current.lvlstart >= 177877000 && current.lvlstart < 177878000)){
            vars.Reset = true;
            vars.IsLoading = true;
            vars.tempvar = true;
            vars.Setup = false;
        }
    }
    
    else{
        if(vars.tempvar){
            vars.tempvar = false;
        }
        else{
            return false;
        }
    }
}

split{return vars.Split;}
onSplit{vars.Split = false;
    File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+":  :"+"SPLIT: split" + '\n');
}

isLoading{return vars.IsLoading;}

reset{return vars.Reset;}
onReset{vars.Reset = false;
    File.AppendAllText(vars.logs, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")+":  :"+"RESET: reset" + '\n');

}

start{
    // print("yippee");
    return true;
    }
