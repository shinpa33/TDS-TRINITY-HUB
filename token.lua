local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 10초마다 반복하는 무한 루프
while true do
    task.wait(3) -- 3초 대기
    
    local character = LocalPlayer.Character
    -- 내 캐릭터가 없거나 죽었으면 건너뜀
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then 
        continue 
    end
    
    local myRoot = character.HumanoidRootPart
    local myHumanoid = character.Humanoid
    
    -- TDS 구조상 적들이 모여있는 NPCs 폴더 찾기
    local npcsFolder = workspace:FindFirstChild("NPCs")
    if not npcsFolder then continue end
    
    local closestEnemy = nil
    local shortestDistance = math.huge -- 거리를 무한대로 초기화
    
    -- NPCs 폴더 안의 모든 적을 탐색
    for _, enemy in ipairs(npcsFolder:GetChildren()) do
        -- 적 모델 안에 HumanoidRootPart(위치 기준점)가 있는지 확인
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
        
        if enemyRoot then
            -- 내 캐릭터와 적 사이의 거리 계산
            local distance = (myRoot.Position - enemyRoot.Position).Magnitude
            
            -- 가장 가까운 적 찾기
            if distance < shortestDistance then
                shortestDistance = distance
                closestEnemy = enemyRoot
            end
        end
    end
    
    -- 가장 가까운 적을 찾아냈다면 그 좌표로 내 캐릭터 이동시키기
    if closestEnemy then
        print("적 감지 완료! 해당 위치로 이동합니다: ", closestEnemy.Parent.Name)
        myHumanoid:MoveTo(closestEnemy.Position)
    else
        print("현재 맵에 감지된 적이 없습니다.")
    end
end
