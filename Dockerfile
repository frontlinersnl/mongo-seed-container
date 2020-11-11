FROM mongo
WORKDIR /tmp/mongoseed
COPY ./scripts .
RUN chmod +x ./mongo-seed.sh
CMD [ "./mongo-seed.sh" ]