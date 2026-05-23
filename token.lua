local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 3초마다 반복하는 무한 루프
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
    
    local farthestEnemy = nil
    local longestDistance = 0 -- 거리를 0으로 초기화 (가장 먼 거리를 찾기 위함)
    
    -- NPCs 폴더 안의 모든 적을 탐색
    for _, enemy in ipairs(npcsFolder:GetChildren()) do
        -- 적 모델 안에 HumanoidRootPart(위치 기준점)가 있는지 확인
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
        
        if enemyRoot then
            -- 내 캐릭터와 적 사이의 거리 계산
            local distance = (myRoot.Position - enemyRoot.Position).Magnitude
            
            -- [수정된 부분] 거리가 longestDistance보다 '크면' 갱신
            if distance > longestDistance then
                longestDistance = distance
                farthestEnemy = enemyRoot
            end
        end
    end
    
    -- 가장 먼 적을 찾아냈다면 그 좌표로 내 캐릭터 이동시키기
    if farthestEnemy then
        print("가장 먼 적 감지 완료! 해당 위치로 이동합니다: ", farthestEnemy.Parent.Name)
        myHumanoid:MoveTo(farthestEnemy.Position)
    else
        print("현재 맵에 감지된 적이 없습니다.")
    end
end
