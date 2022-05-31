package team13.kuje.airbnb.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.transaction.annotation.Transactional;
import team13.kuje.airbnb.controller.model.EventDto;

@DisplayName("EventService 클래스")
@SpringBootTest
@Transactional
@Sql({"/testdb/schema.sql", "/testdb/data.sql"})
class EventServiceTest {

	@Autowired
	EventService eventService;

	@Test
	void 메인_이벤트를_조회하면_메인_이벤트리스트가_반환된다() {
		List<EventDto> result = eventService.findByCategoryTag("main");

		assertThat(result.size()).isEqualTo(1);
	}

	@Test
	void 메인이_아닌_이벤트를_조회하면_메인이_아닌_이벤트리스트가_반환된다() {
		List<EventDto> result = eventService.findByCategoryTag("list");

		assertThat(result.size()).isEqualTo(3);
	}

	@Test
	void 잘못된_이벤트를_조회하면_예외를_발생한다() {
		assertThatThrownBy(() -> eventService.findByCategoryTag("error_tag")).isInstanceOf(
			IllegalArgumentException.class);
	}
}
