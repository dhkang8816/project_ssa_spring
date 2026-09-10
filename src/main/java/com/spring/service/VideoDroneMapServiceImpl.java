package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dao.VideoDroneMapDAO;
import com.spring.dto.VideoDroneMapVO;
import com.spring.yolo.AIStreamBridgeService;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class VideoDroneMapServiceImpl implements VideoDroneMapService {

    private final VideoDroneMapDAO videoDroneMapDAO;
    
    //  [아키텍처 완치 핵심] 컨트롤러 대신, 비즈니스 캐시 서랍장을 쥐고 있는 AIStreamBridgeService를 정석 주입!
    private final AIStreamBridgeService aiStreamBridgeService;

    @Override
    public List<VideoDroneMapVO> getAllMappings() throws Exception {
        return videoDroneMapDAO.selectAllMappings();
    }

    @Override
    public String getDroneIdBySource(String sourceKey) throws Exception {
        return videoDroneMapDAO.getDroneIdBySource(sourceKey);
    }

    @Override
    @Transactional // 정석대로 안전한 트랜잭션 보장
    public void modifyDroneMapping(String sourceKey, String droneId) throws Exception {
        // 1. 실물 DB 영구 업데이트 수행
        VideoDroneMapVO vo = VideoDroneMapVO.builder()
                .sourceKey(sourceKey)
                .droneId(droneId)
                .build();
        videoDroneMapDAO.updateDroneMapping(vo);
        
        // 2.  [결합도 완전 박멸 완료] 
        // 컨트롤러의 static 메서드를 찌르던 코드를 완전 폐기하고, 
        // 주입받은 서비스 인스턴스를 통해 깔끔하게 인메모리 전역 캐시를 리프레시 새로고침합니다!
        aiStreamBridgeService.updateInmemoryDroneCache(sourceKey, droneId);
    }
}
