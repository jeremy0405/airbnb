package team13.kuje.airbnb.service;

import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import team13.kuje.airbnb.controller.model.PlaceDto;
import team13.kuje.airbnb.domain.Place;
import team13.kuje.airbnb.domain.Position;
import team13.kuje.airbnb.repository.PlaceRepository;

@Service
@RequiredArgsConstructor
public class PlaceService {

	public static final int ANGLE_OF_SEARCH_RANGE = 2;
	private final PlaceRepository placeRepository;

	/**
	 * northEastPosition : inputPosition 기준 ANGLE_OF_SEARCH_RANGE 를 더한 오른쪽 위 대각선 위치
	 * southWestPosition : inputPosition 기준 ANGLE_OF_SEARCH_RANGE 를 뺀 왼쪽 아래 대각선 위치
	 */
	@Transactional(readOnly = true)
	public List<PlaceDto> findByPosition(String tag, Double lat, Double lng) {
		validateTag(tag);

		Position inputPosition = new Position(lat, lng);

		Position northEastPosition = new Position(inputPosition.getLat() + ANGLE_OF_SEARCH_RANGE, inputPosition.getLng() + ANGLE_OF_SEARCH_RANGE);
		Position southWestPosition = new Position(inputPosition.getLat() - ANGLE_OF_SEARCH_RANGE, inputPosition.getLng() - ANGLE_OF_SEARCH_RANGE);

		List<Place> places = placeRepository.findByPosition(southWestPosition, northEastPosition);

		return places.stream()
			.map(p -> new PlaceDto(p, inputPosition))
			.collect(Collectors.toList());
	}

	private void validateTag(String tag) {
		if (tag.equals("map")) {
			return;
		}
		throw new IllegalArgumentException("유효하지 않은 category_tag 입니다.");
	}
}
