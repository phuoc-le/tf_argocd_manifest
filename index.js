
const hello = async (event, context) => {
    try {
        return {
            statusCode: 200,
            body: JSON.stringify({
                message: "Hello from Lambda!",
            }),
        };
    } catch (err) {
        console.log(err);
        return err;
    }
};

module.exports = { hello }