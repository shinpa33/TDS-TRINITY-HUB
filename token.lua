local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 5초마다 반복하는 무한 루프
while true do
    task.wait(5) -- [수정] 3초에서 5초 대기로 변경
    
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
            
            -- 거리가 longestDistance보다 '크면' 갱신 (가장 먼 적)
            if distance > longestDistance then
                longestDistance = distance
                farthestEnemy = enemyRoot
            end
        end
    end
    
    -- 가장 먼 적을 찾아냈다면 그 좌표로 내 캐릭터 이동시키고 점프하기
    if farthestEnemy then
        print("가장 먼 적 감지 완료! 해당 위치로 이동 및 점프합니다: ", farthestEnemy.Parent.Name)
        
        -- 1. 가장 먼 적의 위치로 이동 명령
        myHumanoid:MoveTo(farthestEnemy.Position)
        
        -- 2. [추가] 이동 명령을 내린 직후에 점프 실행
        myHumanoid.Jump = true
    else
        print("현재 맵에 감지된 적이 없습니다.")
    end
end
