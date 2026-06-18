package com.example.CineRate.service;

import com.example.CineRate.model.Review;
import com.example.CineRate.model.Movie;
import com.example.CineRate.repository.ReviewRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;

@Service
public class ReviewService {

    @Autowired
    private ReviewRepository reviewRepository;

    @Autowired
    private MongoTemplate mongoTemplate;

    public Review createReview(String body, String imdbLink) {
        Review review = reviewRepository.insert(new Review(body, imdbLink));

        mongoTemplate.update(Movie.class)
                .matching(Criteria.where("imdbLink").is(imdbLink))
                .apply(new Update().push("reviews").value(review))
                .first();

        return review;
    }
}