package com.spring.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.spring.dao.VideoDroneMapDAO;
import com.spring.dto.VideoDroneMapVO;
import com.spring.yolo.AIStreamBridgeController; // 전역 캐시 서랍장 접근용
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class VideoDroneMapServiceImpl implements VideoDroneMapService {

    private final VideoDroneMapDAO videoDroneMapDAO;

    @Override
    public List<VideoDroneMapVO> getAllMappings() throws Exception {
        return videoDroneMapDAO.selectAllMappings();
    }

    @Override
    public String getDroneIdBySource(String sourceKey) throws Exception {
        return videoDroneMapDAO.getDroneIdBySource(sourceKey);
    }

    @Override
    @Transactional //  정석대로 안전한 트랜잭션 보장
    public void modifyDroneMapping(String sourceKey, String droneId) throws Exception {
        // 1. 실물 DB 영구 업데이트 수행
        VideoDroneMapVO vo = VideoDroneMapVO.builder()
                .sourceKey(sourceKey)
                .droneId(droneId)
                .build();
        videoDroneMapDAO.updateDroneMapping(vo);
        
        // 2. [비즈니스 로직] 무한 중계 빨대 엔진의 전역 캐시 메모리 즉시 동기화 리프레시
        AIStreamBridgeController.updateInmemoryDroneCache(sourceKey, droneId);
    }
}
