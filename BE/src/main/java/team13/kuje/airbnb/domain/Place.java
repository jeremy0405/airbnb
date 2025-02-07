package team13.kuje.airbnb.domain;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Place {

	public static final double AVERAGE_SPEED = 80.;
	public static final int HOUR_TO_MIN = 60;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	private String title;
	@Column(length = 1000)
	private String imageUrl;

	@Embedded
	private Position position;


	public int calculateTime(Position inputPosition) {
		double distance = position.calculateDistance(inputPosition);

		return (int) ((distance / AVERAGE_SPEED) * HOUR_TO_MIN);
	}

}
