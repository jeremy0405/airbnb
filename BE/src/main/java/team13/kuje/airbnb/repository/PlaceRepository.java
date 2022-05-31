package team13.kuje.airbnb.repository;


import java.util.List;
import javax.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;
import team13.kuje.airbnb.domain.Place;
import team13.kuje.airbnb.domain.Position;

@Repository
@RequiredArgsConstructor
public class PlaceRepository {

	private final EntityManager entityManager;

	public List<Place> findByPosition(Position southWestPosition, Position northEastPosition) {
		return entityManager.createQuery(
				"select p from Place p "
					+ "where p.position.lat between :minLat and :maxLat "
					+ "and p.position.lng between :minLng and :maxLng", Place.class)
			.setParameter("minLat", southWestPosition.getLat())
			.setParameter("maxLat", northEastPosition.getLat())
			.setParameter("minLng", southWestPosition.getLng())
			.setParameter("maxLng", northEastPosition.getLng())
			.getResultList();
	}
}
