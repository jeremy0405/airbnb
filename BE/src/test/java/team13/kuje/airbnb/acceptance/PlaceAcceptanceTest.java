package team13.kuje.airbnb.acceptance;

import io.restassured.RestAssured;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;

import static io.restassured.RestAssured.given;
import static org.hamcrest.core.IsEqual.equalTo;

@DisplayName("Place API 테스트")
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
class PlaceAcceptanceTest {

	@LocalServerPort
	int port;

	@BeforeEach
	void setUp() {
		RestAssured.port = port;
	}

	@Test
	void 만약_위경도값이_주어진_경우_가까운_여행지가_조회된다() {
		given()
			.accept(MediaType.APPLICATION_JSON_VALUE)

		.when()
			.get("/api/place?category_tag=map&lat=37.123123123123&lng=127.123123123123123")

		.then()
			.statusCode(HttpStatus.OK.value())
			.assertThat()
			.body("data[0].title", equalTo("서울"));

	}

	@Test
	void 만약_위경도값이_주어지지_않은_경우_서울기준_가까운_여행지가_조회된다() {
		given()
			.accept(MediaType.APPLICATION_JSON_VALUE)

		.when()
			.get("/api/place?category_tag=map")

		.then()
			.statusCode(HttpStatus.OK.value())
			.assertThat()
			.body("data[0].title", equalTo("서울"))
			.body("data[0].time", equalTo(0))
			.body("data[1].title", equalTo("광주"))
			.body("data[1].time", equalTo(21));

	}

}
