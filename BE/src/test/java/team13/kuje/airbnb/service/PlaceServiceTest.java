package team13.kuje.airbnb.service;

import java.util.List;
import javax.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.Transactional;
import team13.kuje.airbnb.controller.model.PlaceDto;
import team13.kuje.airbnb.domain.Place;
import team13.kuje.airbnb.domain.Position;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("PlaceService 클래스")
@SpringBootTest
@Transactional
@Sql({"/testdb/schema.sql", "/testdb/data.sql"})
class PlaceServiceTest {

	@Autowired
	PlaceService placeService;

	@Test
	void 만약_유효하지_않은_태그가_요청되면_예외가_반환된다() {
		assertThatThrownBy(() -> placeService.findByPosition("error_tag", 36., 127.))
			.isInstanceOf(IllegalArgumentException.class);
	}

	@Test
	void 정상적인_요청이_들어오면_현재위치_기준_인기여행지리스트가_반환된다() {
		List<PlaceDto> result = placeService.findByPosition("map", 37., 127.);

		assertThat(result).hasSize(7);
	}

}
